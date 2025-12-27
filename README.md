# nix-darwin

TODO: Try embedded languages with nvim otter.

This will install nix-darwin if you don't already have it.

```bash
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
```

To do a faster install once set up

```bash
rebuild
```

To Upgrade

```bash
upgrade
```

Partially stolen from Ryan Yin's nix-config

## Collect Garbage

```bash
nix store gc
```

Age is sort-of a modern version of mixhttps://github.com/FiloSottile/age/discussions/432

## TODO

- Setting default apps with Duti
- Set macos theme, currently just set dark and orange manually
- Install Rosetta
- Bartender settings or smthn (not possible, instead use sketchy bar but that's currently not working)
- Look into https://github.com/nix-community/nix-init#configuration
- Fix thunderbird setup. Keeps asking for password on my accounts
- use git-hooks to manage quality of this repo https://github.com/cachix/git-hooks.nix
- Clone another one of those nixos configuration setups, in particular the NixOS VM on mac one.
- TODO: Modularize as flake-parts, as modules, etc.
- TODO: Also put this into some kind of better template
- TODO: Make declarative dock https://github.com/dustinlyons/nixos-config/blob/8a14e1f0da074b3f9060e8c822164d922bfeec29/modules/darwin/home-manager.nix#L74
- TODO: Understand https://github.com/cpick/nix-rosetta-builder
- TODO: Find material icons nerd font for eza and such.
- TODO: Eventually make pure (using references to my assets dir)
- TODO: learn how to manage ssh keys in nix
- TODO: Change to use SOPS-Nix. (or lpass)
- Get sketchybar to work
- TODO: Obisidan edits
- TODO: For Claude Code: finish a better setup check more cc theme stuff. Also actually install this more globally.
- Set up nix-based calendar accounts
- TODO: For ruff, Would also be nice to have some kind of PROFILE to distinguish code I'M writing from code that others have written(?)
- TODO: For ruff Add banned imports (e.g. logging, matplotlib, etc. Recommend replacements instead.)
- [nix-ruff] Have vscode turn off auto-fixable linter codes (--linter-args ignore fixable or something)
- [nix-ruff] Figure out if I can disable the display  of a ton of diffent ruff things which are distracting while  still letting it format whatever.
- [nix-ruff] Figure out how to combine ruff fixes and formats (or maybe just format on save?)
- [nix-home-manager] Save some set of AI rules to a place where cursor and other agents can access in MDC form(?)
- [nix] Turn on python.repl.sendtonativerepl (for vscode?)
- [nix] Have a defined Dracula theme. Set all colors for vscode from there
- Disable almost all macos keybindings (in particular for screenshot tools and spotlight search) and remap them to things I used (raycast and rectangle/aerospace)
- Firefox: make basic home screen (No Firefox Home Content)
- Switch lpass to SOPS-nix
- Disable all autofill for firefox

## Claude-Code Specific TODOs

check out https://claudelog.com/configuration/

Add claude code to vscode extensions

TODO: add keybinds
Installed Cursor terminal Shift+Enter key binding
     See /Users/gat/Library/Application Support/Cursor/User/keybindings.json!

TODO: claude code plugins?

TODO: Configure an askpass??

https://github.com/hesreallyhim/awesome-claude-code

TODO: look into https://github.com/dyoshikawa/rulesync

https://github.com/NeoLabHQ/context-engineering-kit

https://github.com/Haleclipse/CCometixLine

https://github.com/diet103/claude-code-infrastructure-showcase/tree/main

https://github.com/disler/just-prompt/tree/main/.claude/commands

https://github.com/GWUDCAP/cc-sessions

https://github.com/davila7/claude-code-templates

SUPER COOL:
https://github.com/SuperClaude-Org/SuperClaude_Framework

https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor

https://github.com/ruvnet/claude-code-flow

(so many more orchestrators)

https://github.com/sirmalloc/ccstatusline

https://github.com/nizos/tdd-guard

https://github.com/evmts/tevm-monorepo/blob/main/.claude/commands/commit.md

https://github.com/liam-hq/liam/blob/main/.claude/commands/create-pull-request.md

https://github.com/metabase/metabase/blob/master/.claude/commands/fix-issue.md

https://github.com/metabase/metabase/blob/master/.claude/commands/fix-pr.md

https://github.com/scopecraft/command/blob/main/.claude/commands/create-command.md

https://github.com/spylang/spy/blob/main/CLAUDE.md

https://github.com/badass-courses/course-builder/blob/main/CLAUDE.md

https://github.com/eastlondoner/cursor-tools/blob/main/CLAUDE.md

https://github.com/soramimi/Guitar/blob/master/CLAUDE.md

https://github.com/basicmachines-co/basic-memory/blob/main/CLAUDE.md

```

          # services.dropbox.enable = true; # Doesn't work? For dropbox cli it seems
          # services.syncthing.enable = true; # Doesn't work for some reason
          # services.ludusavi.enable = true; # Doesn't exist
          # services.flameshot.enable = false; # Doesn't exist
          # services.gpg-agent = {
          #   enable = true;
          #   enableZshIntegration = true;
          #   enableNushellIntegration = true;
          # };
```

```
    # TODO: Global nix-colors, which is fine but they only have Base16 standard. Will define my own for now.
    # nix-colors= {url = "github:misterio77/nix-colors"};
```

```
#Initial installation: sudo nix run nix-darwin -- switch --flake ~/.config/nix-config
# Subsequent updates: darwin-rebuild switch --flake ~/.config/nix-config
#
# nix-darwin: https://nix-darwin.github.io/nix-darwin/manual/index.html
# home-manager: https://nix-community.github.io/home-manager/options.xhtml
```
