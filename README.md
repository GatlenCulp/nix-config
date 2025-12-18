# nix-darwin

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


## Collect Garbage

```bash
nix-collect-garbage
```


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
