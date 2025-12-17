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

Everything should happen or be imported into `flake.nix`

## Collect Garbage

```bash
nix-collect-garbage
```

## Notes

NixOS inspired setup:
https://github.com/notusknot/dotfiles-nix

And a nix-darwin setup:
https://github.com/heywoodlh/nix-darwin-flake

## TODO

- Add everything from here:
  https://github.com/GatlenCulp/macos_setup/tree/main/src/macos
- Setting default apps with Duti
- Set theme

```bash
#!/user/bin/env bash

echo "Setting desktop preferences..."

abs_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Set wallpaper
osascript -e "tell application 'Finder' to set desktop picture to POSIX file \'${abs_dir}/wallpaper.jpg\'"
```

- Install Rosetta
- Bartender settings or smthn

_Note: Some nix-darwin things are mirrored in home-manager, make sure to use proper settings._

To look into:

- https://github.com/nix-community/nix-init#configuration

Home-Manager's Email Module Example:
https://beb.ninja/post/email/

Can select branches. Also unstable is tested. Also unstable includes darwin pacakges. But also unstable breaks!

TODO: use git-hooks https://github.com/cachix/git-hooks.nix
