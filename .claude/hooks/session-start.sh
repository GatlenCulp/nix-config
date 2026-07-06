#!/usr/bin/env bash
# Claude Code cloud-environment install script — general purpose, repo-agnostic.
# Detects the project stack from lockfiles/manifests and installs dependencies.
# For this repo it also bootstraps Nix/Lix so flakes can be evaluated and tested
# (nix flake check, nix eval, nix build, ...) in the cloud environment.
# Idempotent and safe to re-run. Steps fail soft; a summary prints at the end.
set -uo pipefail

cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"

WARN=(); OK=()
log()  { printf '▸ %s\n' "$1"; }
ok()   { printf '  ✓ %s\n' "$1"; OK+=("$1"); }
warn() { printf '  ⚠ %s\n' "$1"; WARN+=("$1"); }
has()  { command -v "$1" >/dev/null 2>&1; }
# Run a command; on failure record a warning but keep going.
try()  { if "$@"; then return 0; else warn "failed: $*"; return 1; fi; }

# ── Nix / Lix ──────────────────────────────────────────────────────────────
# Ensures a working Nix CLI (with flakes) so this flake can be evaluated and
# built in the cloud environment. Prefers Lix — the fork this config targets on
# macOS — and falls back to upstream Nix, which is CLI-compatible, when the Lix
# installer is not reachable (e.g. blocked by an egress policy). Only auto-runs
# in Claude Code's remote environment; a local machine that already manages Nix
# is left untouched.
NIX_VERSION="${NIX_VERSION:-2.34.2}"   # upstream fallback; override via env

# Reachable through the current egress policy? (short timeout, no retries)
nix_reachable() { curl -fsS --connect-timeout 5 --max-time 10 -o /dev/null "$1" 2>/dev/null; }

# Source an existing Nix installation into THIS script run (picks up a cached
# /nix from a previous session, or one we just installed). No-op if absent.
nix_source() {
  export USER="${USER:-$(id -un)}"
  # Multi-user (daemon) profile first, then single-user.
  for p in /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
           "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
    [ -e "$p" ] && . "$p"
  done
}

# Persist Nix activation to the session env file so every later tool call in
# this session finds `nix` on PATH.
nix_persist() {
  [ -n "${CLAUDE_ENV_FILE:-}" ] || return 0
  # Idempotent: only append the block once.
  grep -q 'nix-profile/etc/profile.d/nix.sh' "$CLAUDE_ENV_FILE" 2>/dev/null && return 0
  {
    echo 'export USER="${USER:-$(id -un)}"'
    echo '[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    echo '[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"'
  } >> "$CLAUDE_ENV_FILE"
}

install_nix() {
  local single_user=0
  # Root without systemd (typical container) → single-user install; otherwise
  # the modern multi-user daemon install.
  { [ "$(id -u)" = 0 ] && [ ! -d /run/systemd/system ]; } && single_user=1

  # Trust the agent-proxy CA if present so downloads through it verify.
  [ -f /root/.ccr/ca-bundle.crt ] && export NIX_SSL_CERT_FILE=/root/.ccr/ca-bundle.crt
  # Enable flakes from the first invocation and, for single-user, don't require
  # a build-users group that doesn't exist.
  export NIX_CONFIG="experimental-features = nix-command flakes"
  [ "$single_user" = 1 ] && NIX_CONFIG="$NIX_CONFIG
build-users-group ="

  if nix_reachable "https://install.lix.systems/lix"; then
    log "Installing Lix"
    if [ "$single_user" = 1 ]; then
      try sh -c "curl -sSf -L https://install.lix.systems/lix | sh -s -- install linux --init none --no-confirm"
    else
      try sh -c "curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm"
    fi
  else
    warn "Lix installer unreachable (egress policy); using upstream Nix ${NIX_VERSION}"
    log "Installing Nix ${NIX_VERSION}"
    local url="https://releases.nixos.org/nix/nix-${NIX_VERSION}/install"
    if [ "$single_user" = 1 ]; then
      try sh -c "curl -sS -L '$url' | sh -s -- --no-daemon --yes --no-channel-add"
    else
      try sh -c "curl -sS -L '$url' | sh -s -- --daemon --yes --no-channel-add"
    fi
  fi

  # Persist config so flakes stay enabled for the daemon and future runs.
  if [ -w /etc/nix ] || [ "$(id -u)" = 0 ] || has sudo; then
    local conf; conf="$(printf 'experimental-features = nix-command flakes\n')"
    [ "$single_user" = 1 ] && conf="$conf"$'\nbuild-users-group ='
    if [ "$(id -u)" = 0 ]; then
      mkdir -p /etc/nix && printf '%s\n' "$conf" > /etc/nix/nix.conf
    else
      sudo mkdir -p /etc/nix && printf '%s\n' "$conf" | sudo tee /etc/nix/nix.conf >/dev/null
    fi
  fi
}

if [ -f flake.nix ] || [ -f default.nix ] || [ -f shell.nix ] || [ -f devenv.nix ]; then
  log "Nix / Lix"
  nix_source                              # pick up a cached / pre-existing Nix
  if ! has nix; then
    if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then
      install_nix
      nix_source
    else
      warn "nix not found; skipping auto-install (not a remote session)"
    fi
  fi
  if has nix; then
    nix_persist
    ok "nix ready ($(nix --version 2>/dev/null | head -1))"
  elif [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then
    warn "nix installation did not produce a working 'nix' binary"
  fi
fi

# ── Python ────────────────────────────────────────────────────────────────
if [ -f pyproject.toml ] || ls requirements*.txt >/dev/null 2>&1; then
  log "Python"
  if [ -f uv.lock ] && has uv; then
    try uv sync && ok "uv sync"
  elif [ -f poetry.lock ] && has poetry; then
    try poetry install && ok "poetry install"
  elif [ -f Pipfile.lock ] && has pipenv; then
    try pipenv install --dev && ok "pipenv install"
  elif ls requirements*.txt >/dev/null 2>&1; then
    has uv && VENV="uv venv" || VENV="python3 -m venv"
    [ -d .venv ] || $VENV .venv
    # shellcheck disable=SC1091
    . .venv/bin/activate
    PIP="pip"; has uv && PIP="uv pip"
    for r in requirements*.txt; do try $PIP install -r "$r"; done
    ok "pip install (requirements*.txt)"
  elif [ -f pyproject.toml ]; then
    PIP="pip"; has uv && PIP="uv pip"
    try $PIP install -e . && ok "pip install -e ."
  fi
fi

# ── Node / JS (root + common frontend subdirs) ───────────────────────────
node_install() {
  local dir="$1"; [ -f "$dir/package.json" ] || return 0
  ( cd "$dir"
    if   [ -f bun.lock ]      || [ -f bun.lockb ]      && has bun;  then try bun install
    elif [ -f pnpm-lock.yaml ]                         && has pnpm; then try pnpm install
    elif [ -f yarn.lock ]                              && has yarn; then try yarn install
    elif [ -f package-lock.json ]                      && has npm;  then try npm ci || try npm install
    elif has npm; then try npm install
    else return 1; fi
  ) && ok "node deps ($dir)"
}
if [ -f package.json ] || ls */package.json >/dev/null 2>&1; then
  log "Node / JS"
  node_install .
  for d in web frontend client app ui; do [ -d "$d" ] && node_install "$d"; done
fi

# ── Other ecosystems ─────────────────────────────────────────────────────
[ -f Cargo.toml ]     && { log "Rust";   has cargo    && try cargo fetch          && ok "cargo fetch"; }
[ -f go.mod ]         && { log "Go";     has go       && try go mod download      && ok "go mod download"; }
[ -f Gemfile ]        && { log "Ruby";   has bundle   && try bundle install       && ok "bundle install"; }
[ -f composer.json ]  && { log "PHP";    has composer && try composer install     && ok "composer install"; }

# ── pre-commit ───────────────────────────────────────────────────────────
if [ -f .pre-commit-config.yaml ]; then
  log "pre-commit"
  RUN=""; has pre-commit && RUN="pre-commit"
  [ -z "$RUN" ] && has uv && RUN="uv run pre-commit"
  [ -z "$RUN" ] && has uvx && RUN="uvx pre-commit"
  [ -z "$RUN" ] && has pipx && { pipx install pre-commit >/dev/null 2>&1 && RUN="pre-commit"; }
  if [ -n "$RUN" ]; then try $RUN install --install-hooks && ok "hooks installed"
  else warn "pre-commit config present but no runner (uv/pipx/pre-commit) found"; fi
fi

# ── Project-defined bootstrap (informational) ────────────────────────────
if [ -f Makefile ] && grep -qE '^(setup|install|bootstrap|init):' Makefile 2>/dev/null; then
  log "Note: Makefile defines a setup/bootstrap target — consider 'make setup'"
fi
if [ -f Taskfile.yml ] && grep -qE '^\s+(setup|install|bootstrap):' Taskfile.yml 2>/dev/null; then
  log "Note: Taskfile defines a setup task — consider 'task setup'"
fi

# ── Secrets (warn-only; nothing is ever written) ─────────────────────────
for ex in .env.example .env.sample .env.template; do
  [ -f "$ex" ] || continue
  log "Required env vars (from $ex)"
  while IFS= read -r key; do
    [ -z "$key" ] && continue
    [ -z "${!key:-}" ] && warn "\$$key unset" || ok "\$$key set"
  done < <(grep -vE '^\s*#' "$ex" | grep -E '^\s*[A-Za-z_][A-Za-z0-9_]*\s*=' | sed -E 's/\s*=.*//; s/\s//g' | sort -u)
done

# ── Summary ──────────────────────────────────────────────────────────────
echo
echo "── Setup summary ─────────────────────────────"
printf '  ✓ %s\n' "${OK[@]:-nothing installed}"
[ ${#WARN[@]} -gt 0 ] && printf '  ⚠ %s\n' "${WARN[@]}"
echo "──────────────────────────────────────────────"
[ ${#WARN[@]} -eq 0 ] && echo "✅ Ready" || echo "⚠ Ready with warnings (${#WARN[@]})"
exit 0
