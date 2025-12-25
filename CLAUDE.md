# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **nix-darwin** configuration flake for managing a macOS system declaratively using Nix. It combines nix-darwin (system-level configuration) with home-manager (user-level configuration) to manage packages, applications, system settings, and dotfiles.

## Essential Commands

### Development Workflow
```bash
# Quick rebuild (most common)
rebuild
# Expands to: sudo darwin-rebuild switch --flake ~/.config/nix-config --show-trace --impure

# Edit configuration
config
# Expands to: $EDITOR ~/.config/nix-config

# Upgrade all packages and flake inputs
upgrade
# Expands to: topgrade (which runs flake update + rebuild)

# Initial installation (first time only)
sudo nix run nix-darwin -- switch --flake ~/.config/nix-config
```

### Validation
```bash
# Check flake syntax and evaluation
nix flake check

# Show what would change without applying
darwin-rebuild build --flake ~/.config/nix-config --show-trace
```

### Maintenance
```bash
# Clean up old generations
nix-collect-garbage

# List repo structure
lsr
# Expands to: eza -T --git-ignore
```

## Architecture

### Flake Structure

The main entry point is `flake.nix`, which orchestrates the entire configuration:

- **Inputs**: Uses both stable (`nixpkgs-stable-darwin`) and unstable (`nixpkgs-unstable`) channels
  - nix-darwin follows stable for system stability
  - home-manager and most packages follow unstable for latest features
- **Key flake inputs**: nix-darwin, home-manager, nix-vscode-extensions, nur, nixvim, nvix (custom neovim config)

### Module Organization

Configuration is split into two main categories:

#### Darwin Modules (`modules/darwin/`)
System-level macOS configuration:
- **`system-packages.nix`**: Organized into profiles (browsers, dev-utils, devops, git, python, rust, security, etc.)
  - Profiles are concatenated together in the `selected` list
  - Easy to add/remove entire categories of packages
- **`homebrew.nix`**: Casks and Mac App Store apps that aren't available in nixpkgs
- **`system-defaults.nix`**: macOS system preferences (Dock, Finder, menu bar, etc.)
- **`custom-system-packages.nix`**: Custom derivations and overlays
- **`fonts.nix`**: Font packages

#### Home Manager Modules (`modules/home/`)
User-level configuration:
- **`terminal/`**: Shell configurations, terminal programs, and CLI tools
  - `shell-config.nix`: Shared shell initialization (exports, API keys from secrets)
  - `terminal-programs.nix`: CLI tool configurations (git, atuin, zellij, bat, eza, etc.)
  - `starship-config.nix`, `fastfetch-config.nix`, `nixvim.nix`
- **`vscode/`**: VS Code settings, extensions, and keybindings
- **`firefox/`**: Firefox configuration and extensions
- **`applications.nix`**: GUI application settings
- **`accounts.nix`**: Email/calendar account configurations
- **`ruff.nix`**: Python linter/formatter settings
- **`aerospace-config.nix`**: Window manager configuration
- **`sketchybar.nix`**: Menu bar customization (currently disabled)

### Secrets Management

The flake imports `/Users/gat/.config/nix-config/secrets/secrets.nix` which contains:
- API keys (OpenAI, Anthropic, Gemini, PyPI, HuggingFace)
- AWS credentials and profiles
- Other sensitive configuration

**Important**: This file is gitignored and must exist locally. Never commit secrets to the repository.

### Configuration Assembly

The flake follows this assembly pattern:

1. **Import helper functions** that load module files (e.g., `systemPackages = pkgs: import "${self}/modules/darwin/system-packages.nix"`)
2. **`homeManagerConfig`**: Combines all home-manager modules into user configuration
3. **`configuration`**: Main darwin system configuration that:
   - Sets up nixpkgs overlays (nix-vscode-extensions, nur)
   - Configures environment paths and system packages
   - Imports nix-homebrew for managing Homebrew declaratively
   - Integrates home-manager with nixvim plugins from nvix
4. **Output**: Single darwinConfiguration named "gatty"

## Key Integrations

### Neovim (nixvim + nvix)
Uses a custom flake (`nvix`) with modular plugin configurations:
- Plugins: ai, common, lang, lsp, lualine, snacks, autosession, blink-cmp, buffer, firenvim, git, noice, precognition, smear-cursor, tex, treesitter, ux

### VS Code
- Extensions managed via nix-vscode-extensions overlay
- Settings and keybindings in `modules/home/vscode/`
- Disabled Cmd+L keybinding (likely for Claude Code integration)

### Shell Environment
- Primary shell: zsh with prezto framework
- Alternative shells enabled: bash, fish, nushell
- Vi mode enabled in zsh
- API keys exported automatically via shell-config.nix
- Pager: `ov` (replaces less)
- File listing: `eza` with Dracula theme
- Shell history: `atuin` with Dracula theme

### Theme
Dracula theme is used consistently across:
- Terminal (bat, eza, atuin)
- Zellij
- VS Code (configured via settings)

## Development Patterns

### Adding a New Package
1. Find the appropriate profile in `modules/darwin/system-packages.nix`
2. Add the package name to that profile's list
3. Run `rebuild` to apply

For packages not in nixpkgs:
- Add to `modules/darwin/homebrew.nix` (brews or casks)
- Add to `modules/darwin/custom-system-packages.nix` for custom derivations

### Adding a New Program Configuration
1. Add configuration to appropriate file in `modules/home/terminal/` or `modules/home/`
2. Merge into the `programs` attribute in `homeManagerConfig`
3. Run `rebuild`

### Modifying System Defaults
Edit `modules/darwin/system-defaults.nix` and run `rebuild`. Changes apply to Dock, Finder, menu bar, and NSGlobalDomain preferences.

## Important Notes

- **Impure mode required**: The rebuild command uses `--impure` flag (needed for secrets.nix)
- **Platform**: aarch64-darwin (Apple Silicon)
- **State versions**: system.stateVersion = 5, home.stateVersion = "25.05"
- **Primary user**: "gat" (hardcoded in several places)
- **Git template dir**: `~/.git-template` must exist for pre-commit hook auto-initialization
- **Lix**: Uses Lix (Nix fork) as the package manager

## Claude Code Permissions

The `.claude/settings.local.json` grants auto-approval for:
- `darwin-rebuild switch` (for applying configuration changes)
- `nix flake check` (for validation)
- `himalaya --version` (email client)
- WebSearch and WebFetch for github.com

When making configuration changes, Claude Code can directly run `rebuild` without additional approval.
