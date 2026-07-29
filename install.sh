#!/usr/bin/env bash
#
# install.sh — bootstrap this nix-darwin configuration on a fresh macOS machine.
#
# One-liner (after this is on the default branch):
#
#   curl -fsSL https://raw.githubusercontent.com/GatlenCulp/nix-config/main/install.sh | bash
#
# What it does, in order:
#   1. Sanity-checks the machine (macOS, Apple Silicon, not root).
#   2. Ensures the Xcode Command Line Tools (git + a C compiler) are present.
#   3. Installs Rosetta 2 (Intel-only casks + the Intel Homebrew prefix need it).
#   4. Installs Lix (the Nix implementation this flake pins) via the Lix installer.
#   5. Clones this config to ~/.config/nix-config.
#   6. Clones the local flake dependency (nix-gat-vscode) that flake.nix expects
#      at /Users/gat/nix/nix-gat-vscode.
#   7. Checks the sops age key + optional plaintext secrets file.
#   8. Moves the Lix installer's /etc/nix/nix.conf aside so nix-darwin can own it,
#      then runs the first `darwin-rebuild switch` to build the system.
#
# Everything is idempotent: re-running skips steps that are already done.
#
# Configuration (override by exporting before running):
#   NIXCONFIG_REPO        git URL of this repo
#   NIXCONFIG_BRANCH      branch to clone (default: main)
#   NIXCONFIG_DIR         where to clone it (default: ~/.config/nix-config)
#   NIXCONFIG_FLAKE       darwinConfigurations.<name> to build (default: gatty)
#   NIX_GAT_VSCODE_REPO   git URL of the nix-gat-vscode flake dependency
#   NIX_GAT_VSCODE_DIR    where to clone it (default: ~/nix/nix-gat-vscode)
#   ASSUME_YES=1          don't prompt for confirmation, just go

set -euo pipefail

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------
REPO_URL="${NIXCONFIG_REPO:-https://github.com/GatlenCulp/nix-config.git}"
REPO_BRANCH="${NIXCONFIG_BRANCH:-main}"
CONFIG_DIR="${NIXCONFIG_DIR:-$HOME/.config/nix-config}"
FLAKE_NAME="${NIXCONFIG_FLAKE:-gatty}"

# flake.nix pins this as a local input: git+file:/Users/gat/nix/nix-gat-vscode
VSCODE_REPO="${NIX_GAT_VSCODE_REPO:-https://github.com/GatlenCulp/nix-gat-vscode.git}"
VSCODE_DIR="${NIX_GAT_VSCODE_DIR:-$HOME/nix/nix-gat-vscode}"

# sops-nix decryption identity (see hosts/gatty.nix -> host.sops.ageKeyFile)
AGE_KEY_FILE="$HOME/.config/sops/age/keys-nix-sops.txt"

LIX_INSTALLER_URL="https://install.lix.systems/lix"
NIX_DARWIN_FLAKE="github:LnL7/nix-darwin/nix-darwin-25.11"

ASSUME_YES="${ASSUME_YES:-0}"

# ----------------------------------------------------------------------------
# Pretty logging
# ----------------------------------------------------------------------------
if [ -t 1 ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; RED=$'\033[31m'; GREEN=$'\033[32m'
  YELLOW=$'\033[33m'; BLUE=$'\033[34m'; RESET=$'\033[0m'
else
  BOLD=''; DIM=''; RED=''; GREEN=''; YELLOW=''; BLUE=''; RESET=''
fi

step() { printf '\n%s▸ %s%s\n' "$BOLD$BLUE" "$*" "$RESET"; }
info() { printf '  %s\n' "$*"; }
ok()   { printf '  %s✓%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '  %s⚠%s %s\n' "$YELLOW" "$RESET" "$*"; }
die()  { printf '\n%s✗ %s%s\n' "$RED$BOLD" "$*" "$RESET" >&2; exit 1; }

# Read a yes/no from the real terminal even when this script is piped from curl.
confirm() {
  local prompt="$1" reply
  if [ "$ASSUME_YES" = "1" ]; then return 0; fi
  # Open the controlling terminal on fd 3. This fails (rather than just being
  # "missing") when there is no *usable* tty — e.g. /dev/tty exists but the
  # process has no controlling terminal — so we fall through to the safe
  # non-interactive path instead of tripping `set -e` on the read/printf below.
  if exec 3<>/dev/tty 2>/dev/null; then
    printf '  %s%s [y/N] %s' "$BOLD" "$prompt" "$RESET" >&3
    read -r reply <&3 || reply=""
    exec 3>&-
  else
    # No terminal available and not told to assume yes -> be safe.
    warn "No terminal for prompt; pass ASSUME_YES=1 to proceed non-interactively."
    return 1
  fi
  [[ "$reply" =~ ^[Yy]$ ]]
}

# ----------------------------------------------------------------------------
# 1. Preflight
# ----------------------------------------------------------------------------
preflight() {
  step "Preflight checks"

  [ "$(uname -s)" = "Darwin" ] || die "This config is nix-darwin (macOS only). Detected: $(uname -s)."
  ok "macOS detected"

  if [ "$(uname -m)" != "arm64" ]; then
    die "This flake targets aarch64-darwin (Apple Silicon). Detected: $(uname -m)."
  fi
  ok "Apple Silicon (arm64)"

  if [ "$(id -u)" = "0" ]; then
    die "Do not run this as root. Run as your normal user; it will use sudo where needed."
  fi
  ok "Running as $(whoami)"

  if [ "$(whoami)" != "gat" ]; then
    warn "This config hardcodes the user 'gat' and paths under /Users/gat"
    warn "(secrets, sops age key). You are '$(whoami)' — the rebuild will likely"
    warn "fail until those paths are adjusted in hosts/ and secrets/."
    confirm "Continue anyway?" || die "Aborted."
  fi
}

# ----------------------------------------------------------------------------
# 2. Xcode Command Line Tools
# ----------------------------------------------------------------------------
ensure_clt() {
  step "Xcode Command Line Tools"
  if xcode-select -p >/dev/null 2>&1; then
    ok "Already installed ($(xcode-select -p))"
    return
  fi
  info "Triggering the Command Line Tools installer (a GUI dialog will appear)…"
  xcode-select --install >/dev/null 2>&1 || true
  info "Waiting for the installation to finish — complete the dialog, then come back."
  local waited=0 timeout=1800   # give up after 30 minutes
  until xcode-select -p >/dev/null 2>&1; do
    if [ "$waited" -ge "$timeout" ]; then
      die "Command Line Tools still not installed after $((timeout / 60))m. Complete the GUI installer (or run 'xcode-select --install' manually), then re-run this script."
    fi
    sleep 5
    waited=$((waited + 5))
  done
  ok "Command Line Tools installed"
}

# ----------------------------------------------------------------------------
# 2b. Rosetta 2 (x86_64 translation)
# ----------------------------------------------------------------------------
ensure_rosetta() {
  step "Rosetta 2 (x86_64 translation)"
  # Needed on Apple Silicon for anything Intel-only. This config relies on it in
  # two places: nix-homebrew.enableRosetta sets up the /usr/local (Intel) Homebrew
  # prefix, and some casks are Intel-only (e.g. gog-galaxy) — without Rosetta the
  # first rebuild fails their install ("requires Rosetta 2 to be installed").
  if [ -d /Library/Apple/usr/share/rosetta ] || /usr/bin/pgrep -q oahd 2>/dev/null; then
    ok "Rosetta 2 already installed"
    return
  fi
  info "Installing Rosetta 2 (Intel-only casks + the Intel Homebrew prefix need it)…"
  if softwareupdate --install-rosetta --agree-to-license; then
    ok "Rosetta 2 installed"
  else
    warn "Rosetta 2 install failed. Intel-only casks (e.g. gog-galaxy) will fail"
    warn "to install. Re-run manually: softwareupdate --install-rosetta --agree-to-license"
  fi
}

# ----------------------------------------------------------------------------
# 3. Install Lix
# ----------------------------------------------------------------------------
load_nix_env() {
  # Make `nix` available in the current shell after a fresh install.
  local daemon_sh="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  if [ -e "$daemon_sh" ]; then
    # The daemon profile references $ZSH_VERSION / $BASH_VERSION unguarded, which
    # aborts under our `set -u` (nounset). Relax *only* nounset for the source so
    # a genuine failure in the profile still trips errexit; restore it afterward.
    set +u
    # shellcheck disable=SC1090
    . "$daemon_sh"
    set -u
  fi
}

ensure_lix() {
  step "Lix (Nix implementation)"
  load_nix_env
  if command -v nix >/dev/null 2>&1; then
    ok "Nix already present: $(nix --version)"
    return
  fi

  info "Installing Lix via the official installer:"
  info "  $LIX_INSTALLER_URL"
  local flags=(install)
  [ "$ASSUME_YES" = "1" ] && flags+=(--no-confirm)
  curl -sSf -L "$LIX_INSTALLER_URL" | sh -s -- "${flags[@]}"

  load_nix_env
  command -v nix >/dev/null 2>&1 || die "Nix not on PATH after install. Open a new shell and re-run."
  ok "Installed: $(nix --version)"
}

# ----------------------------------------------------------------------------
# 4 + 5. Clone this config and its local flake dependency
# ----------------------------------------------------------------------------
clone_repo() {
  local url="$1" dir="$2" branch="${3:-}" label="$4"
  if [ -d "$dir/.git" ]; then
    ok "$label already cloned at $dir"
    return
  fi
  if [ -e "$dir" ]; then
    die "$dir exists but is not a git repo. Move it aside and re-run."
  fi
  info "Cloning $label -> $dir"
  mkdir -p "$(dirname "$dir")"
  if [ -n "$branch" ]; then
    git clone --branch "$branch" "$url" "$dir"
  else
    git clone "$url" "$dir"
  fi
  ok "Cloned $label"
}

clone_sources() {
  step "Configuration sources"
  clone_repo "$REPO_URL" "$CONFIG_DIR" "$REPO_BRANCH" "nix-config"
  # flake.nix references this as git+file:/Users/gat/nix/nix-gat-vscode.
  clone_repo "$VSCODE_REPO" "$VSCODE_DIR" "" "nix-gat-vscode (local flake input)"
}

# ----------------------------------------------------------------------------
# 6. Secrets
# ----------------------------------------------------------------------------
check_secrets() {
  step "Secrets"

  # Optional plaintext secrets file — build is guarded (missing -> {}), so this
  # is nice-to-have, not required.
  local secrets_nix="$CONFIG_DIR/secrets/secrets.nix"
  local secrets_tmpl="$CONFIG_DIR/secrets/secrets-template.nix"
  if [ ! -e "$secrets_nix" ] && [ -e "$secrets_tmpl" ]; then
    info "Creating a starter secrets/secrets.nix from the template (fill in later)."
    cp "$secrets_tmpl" "$secrets_nix"
    chmod 600 "$secrets_nix"
    ok "Wrote $secrets_nix (edit it to add real values)"
  else
    ok "secrets/secrets.nix present or no template to seed"
  fi

  # sops-nix age key — OPTIONAL. The config's sops wiring only activates when
  # this key is present (see secrets/sops.nix); without it the rebuild simply
  # skips the encrypted secrets instead of failing. So a missing key is just a
  # heads-up (the API keys from secrets.yaml won't be available), not a blocker.
  mkdir -p "$(dirname "$AGE_KEY_FILE")"
  if [ -e "$AGE_KEY_FILE" ]; then
    ok "sops age key found: $AGE_KEY_FILE"
    return
  fi

  warn "sops age key missing: $AGE_KEY_FILE"
  info "sops is optional — the rebuild will proceed and skip the encrypted"
  info "secrets (secrets/secrets.yaml), so the API keys they hold won't be set."
  info ""
  info "To enable them later, restore the key from your password manager /"
  info "another machine and rebuild, e.g.:"
  info "  mkdir -p $(dirname "$AGE_KEY_FILE")"
  info "  pbpaste > $AGE_KEY_FILE   # or copy the file across"
  info "  chmod 600 $AGE_KEY_FILE"
  info ""
}

# ----------------------------------------------------------------------------
# 6b. Make /etc ready for nix-darwin to take over
# ----------------------------------------------------------------------------
prepare_etc() {
  # nix-darwin wants to *own* /etc/nix/nix.conf (and its included nix.custom.conf).
  # The Lix installer already wrote both, so the first `darwin-rebuild switch`
  # aborts with "Unexpected files in /etc" / "custom settings in nix.custom.conf"
  # unless they're moved aside first. Do that here (the documented remediation);
  # nix-darwin regenerates nix.conf with the experimental features this config
  # declares, so nothing is lost. The bootstrap `nix run` below still works
  # because it passes the features via NIX_CONFIG (see first_rebuild).
  # This runs during first-time bootstrap, before nix-darwin has ever managed
  # /etc, so any file present here is an unmanaged one (Lix installer, a session
  # hook, etc.) that must be moved aside whatever wrote it — matching on the Lix
  # header would skip a stale non-Lix nix.conf and re-trigger the very abort we
  # prevent. The .before-nix-darwin guard makes this idempotent and also protects
  # a later nix-darwin-managed nix.conf: after a successful switch both it and its
  # backup exist, so we skip it on re-runs.
  local f moved=0
  for f in /etc/nix/nix.conf /etc/nix/nix.custom.conf; do
    [ -e "$f" ] || continue
    [ -e "$f.before-nix-darwin" ] && continue   # already moved on a previous run
    if [ "$moved" = 0 ]; then step "Preparing /etc for nix-darwin"; fi
    info "Moving $f -> $f.before-nix-darwin"
    sudo mv "$f" "$f.before-nix-darwin"
    moved=1
  done
  [ "$moved" = 1 ] && ok "Installer nix config moved aside"
}

# ----------------------------------------------------------------------------
# 7. First rebuild
# ----------------------------------------------------------------------------
first_rebuild() {
  step "Building the system (first darwin-rebuild switch)"
  info "Target: $CONFIG_DIR#$FLAKE_NAME"
  info "This bootstraps nix-darwin and applies the whole configuration."
  info "It will ask for your password (sudo) and take several minutes."
  info ""
  info "Two macOS prompts to expect during this run:"
  info "  • ${BOLD}App Management${RESET}: activation aborts with 'permission denied when"
  info "    trying to update apps' until you grant your terminal App Management"
  info "    under System Settings > Privacy & Security > App Management, then re-run."
  info "  • ${BOLD}App Store${RESET}: the Mac App Store apps (masApps) only install if you are"
  info "    signed in to the App Store; otherwise they fail with 'MASError error 5'."
  info "Homebrew casks are downloaded up front, so expect a long quiet stretch and"
  info "one or more sudo ${BOLD}Password:${RESET} prompts for pkg-based casks (Office, NordVPN, …)."
  confirm "Run the rebuild now?" || {
    warn "Skipping. Run it yourself when ready:"
    info "  # Move the Lix installer's nix config aside so nix-darwin can take over:"
    info "  sudo mv /etc/nix/nix.conf{,.before-nix-darwin} 2>/dev/null || true"
    info "  sudo mv /etc/nix/nix.custom.conf{,.before-nix-darwin} 2>/dev/null || true"
    info "  sudo NIX_CONFIG='extra-experimental-features = nix-command flakes' \\"
    info "    nix run $NIX_DARWIN_FLAKE#darwin-rebuild -- \\"
    info "    switch --flake $CONFIG_DIR#$FLAKE_NAME --impure \\"
    info "    --override-input nix-gat-vscode $VSCODE_DIR"
    return
  }

  prepare_etc

  # Absolute-path nix + preserved PATH so sudo can find it. Enable the
  # experimental features via NIX_CONFIG rather than a command-line flag: the
  # flag would have to go to `nix run` (not darwin-rebuild, which doesn't know
  # it — that's the `unknown option '--extra-experimental-features'` error),
  # and NIX_CONFIG is also inherited by the nested nix invocations that
  # darwin-rebuild spawns under sudo, in case the installer's defaults aren't
  # picked up there.
  #
  # --override-input points the nix-gat-vscode flake input at wherever we cloned
  # it. flake.nix hardcodes git+file:/Users/gat/nix/nix-gat-vscode, so without
  # this a non-default NIX_GAT_VSCODE_DIR (or user) would fail evaluation. Pass
  # the checkout as a plain path (not a git+file: URL) so a dir containing spaces
  # still parses; the nixpkgs follows in flake.nix are preserved across the override.
  sudo --preserve-env=PATH env PATH="$PATH" \
    NIX_CONFIG="extra-experimental-features = nix-command flakes" \
    nix run "$NIX_DARWIN_FLAKE#darwin-rebuild" -- \
    switch --flake "$CONFIG_DIR#$FLAKE_NAME" \
    --impure --show-trace \
    --override-input nix-gat-vscode "$VSCODE_DIR"

  ok "System built"
}

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------
main() {
  printf '%s\n' "${BOLD}nix-config bootstrap${RESET}"
  printf '%s\n' "${DIM}Lix + nix-darwin + home-manager, config '${FLAKE_NAME}'${RESET}"

  preflight
  ensure_clt
  ensure_rosetta
  ensure_lix
  clone_sources
  check_secrets
  first_rebuild

  step "Done"
  ok "nix-config is installed."
  info "Open a new terminal, then use these aliases from CLAUDE.md:"
  info "  ${BOLD}rebuild${RESET}  — apply config changes"
  info "  ${BOLD}config${RESET}   — edit the config in \$EDITOR"
  info "  ${BOLD}upgrade${RESET}  — update flake inputs + rebuild"
}

main "$@"
