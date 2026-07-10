---
name: add-program-to-nix
description: Add a program to this nix-darwin/home-manager configuration. Use when the user asks to install or add a program/tool/app (e.g. "add ripgrep", "install infisical", "/add-program-to-nix bat"). Resolves the best install source (home-manager → nixpkgs → brew), places it following this repo's conventions, validates, and lands the change with risk-appropriate review.
---

# Add a program to the nix config

Given a program name, install it declaratively in this repo. Follow the
procedure in order; do not skip the classification steps — they decide both
WHERE the program goes and HOW the change lands.

## Step 0 — Understand the program

Before touching any file, determine (web search / `brew info` / upstream repo):

- **Kind**: CLI, GUI/menu-bar app, or background service?
- **Config**: does it read a config file the user might tweak often?
- **Shell hooks**: does it inject into shell init (prompt, history, cd hooks)?
- **Secrets/security**: does it handle credentials, keys, VPN, network filtering?
- **Release cadence**: fast-moving vendor CLI that expects self-updates?

## Step 1 — Classify risk (decides how the change lands)

**PR required** (open a draft PR, let the user review — never straight to main):
- Shell-integration programs — anything hooking shell init (atuin-class,
  prompt/history/keybinding tools, new shells, direnv/zoxide-class cd hooks)
- Background services/daemons — anything creating a launchd agent/daemon or a
  long-running process
- Security/credential tooling — secret managers (infisical!), keychain/VPN/
  network tools, anything running with elevated privileges

**Commit straight to `main`** (CI still gates on push):
- Everything else — ordinary CLIs, GUI apps/casks, fonts, viewers.

## Step 2 — Resolve the install source

**GUI/menu-bar apps: skip straight to brew cask.** Darwin GUI packages in
nixpkgs are chronically second-class in this repo's experience (spotify broke,
ghostty is a cask). Do not spend time on the nixpkgs tier for GUI.

**CLIs, in order:**

1. **home-manager module** — does `programs.<name>` exist?
   (Check: https://home-manager-options.extranix.com, or locally
   `man home-configuration.nix`.) If yes → use it.
2. **nixpkgs** — does the attr exist AND build on aarch64-darwin? All of:
   - attr exists: `nix eval nixpkgs#<attr>.pname`
   - not broken: `nix eval nixpkgs#<attr>.meta.broken` is `false`
   - platform supported: `nix eval --json nixpkgs#<attr>.meta.platforms`
     includes `aarch64-darwin` (or the package is platform-agnostic)
   - on the Mac, confirm buildability with
     `nix build nixpkgs#<attr> --dry-run` (a cache hit is a strong signal);
     on Linux sessions this cannot be proven — say so in the PR/commit.
   If all pass → use it, **unless the staleness rule fires** (next section).
3. **brew** — formula (CLIs) or cask (GUI). Use tap-qualified tokens
   (`owner/tap/name`) when not in homebrew-core, and add the tap to `taps`.
4. **Tier 4 (nowhere packaged)** — ASK THE USER FIRST, then in order:
   a. upstream ships a nix flake → add as flake input;
   b. language ecosystem (uv tool / npm / cargo install) documented in a
      `home/<name>/` module;
   c. document the manual install in a `home/<name>/` stub module.

**Staleness rule (nixpkgs → brew):** fall through to brew if the nixpkgs
version is ≥1 major version behind upstream, OR the tool is a fast-moving
vendor CLI designed to self-update (infisical/gh-class release cadence).
Compare `nix eval nixpkgs#<attr>.version` against the latest upstream release.

## Step 3 — Place it (repo conventions)

- **home-manager module** → `home/<name>/default.nix` containing
  `programs.<name>.enable = true` plus shell **integrations** if offered
  (`enableZshIntegration` etc.). **Never set `settings`/config attrsets** —
  config stays out of Nix so it can become a live-editable file later (see the
  `mkOutOfStoreSymlink` pattern in `home/ghostty`, `home/zellij`). Wire the
  module into `hosts/gatty.nix` (and `hosts/server.nix` only if it makes sense
  on a server).
- **bare nixpkgs CLI (no config, no aliases, no service)** → add to the
  matching profile list in `home/system-packages.nix` (dev-utils, security,
  docs, …) with a short trailing comment. Do NOT create a module directory
  for a one-liner.
- **nixpkgs CLI with config/aliases/launchd** → per-program
  `home/<name>/default.nix` module, wired into the hosts.
- **brew** → `modules/darwin/homebrew.nix`: `brews` for formulas, `casks` for
  apps (under the matching ━━━ section header), `taps` for any tap. Note:
  `homebrew.enable` is currently `false` (fast-deploy toggle) — mention in the
  commit/PR that nothing installs until it is flipped on.
- **Watch for buildEnv collisions**: before adding a package, grep the repo —
  another module may already provide the same binary (e.g. `programs.go`
  provides `go`, `home/claude-code` wraps `claude`, `programs.pandoc` provides
  `pandoc`). Two derivations shipping the same `bin/` name abort the rebuild.

## Step 4 — Validate

1. `nix-instantiate --parse` every changed `.nix` file.
2. `nix run nixpkgs#nixfmt-rfc-style -- <changed .nix files>`.
3. `bash tests/ci.sh` must print `CI RESULT: ALL PASS`.
4. On the Mac (darwin): additionally `darwin-rebuild build --flake
   ~/.config/nix-config --show-trace --impure` before landing; on Linux
   sessions this is impossible — say so and rely on CI.

## Step 5 — Land it

- Per Step 1: innocuous → commit to `main` and push; risky → branch
  `claude/add-<name>`, push, open a **draft PR** describing kind, chosen tier,
  why (including staleness reasoning if brew won), and any post-merge steps
  (rebuild needed? `homebrew.enable`? first-run pairing?).
- Commit message: `feat(<name>): add <name> via <home-manager|nixpkgs|brew>`
  with a body noting the tier reasoning in one line.

## Worked example — infisical

1. **Understand**: CLI secret manager (Infisical vault). Handles credentials.
   Fast vendor release cadence.
2. **Risk**: security/credential tooling → **PR required**, even though the
   change itself is one line.
3. **Resolve**: no `programs.infisical` in home-manager → nixpkgs has
   `infisical` → staleness rule: infisical is a **self-updating vendor CLI**,
   so the vendor clause fires **unconditionally** → brew
   (`brew install infisical/get-cli/infisical`, add the `infisical/get-cli`
   tap). The nixpkgs-vs-upstream version comparison is only the deciding
   factor for *ordinary* CLIs; here it merely corroborates the choice.
4. **Place**: nixpkgs path → `security` profile in `home/system-packages.nix`;
   brew path → `brews` + `taps` in `modules/darwin/homebrew.nix`.
5. **Validate** (Step 4), then open the draft PR (Step 5) noting: "secret
   manager → PR per policy; chose <tier> because <reason>".
