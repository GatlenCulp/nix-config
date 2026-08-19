# nix-darwin

## Fresh install (new machine)

On a clean Apple Silicon Mac, bootstrap everything (Lix + nix-darwin +
home-manager + this config) with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/GatlenCulp/nix-config/main/install.sh | bash
```

`install.sh` is idempotent and walks through: Xcode Command Line Tools →
install Lix → clone this repo to `~/.config/nix-config` → clone the
`nix-gat-vscode` flake dependency → check secrets → first `darwin-rebuild
switch`. It targets the `gatty` config by default; override with env vars
(see the header of `install.sh`, e.g. `NIXCONFIG_FLAKE=work`).

The sops age key at `~/.config/sops/age/keys-nix-sops.txt` (restored from your
password manager / another machine) is **optional but recommended**: the sops
wiring only activates when the key is present, so without it the rebuild still
succeeds — it just skips `secrets/secrets.yaml`, and the API keys it holds won't
be set. Drop the key in and rebuild to pick them up.

TODO: Assign macos terminal to use fira code nerd font
TODO: Try embedded languages with nvim otter.

To fix spotlight not getting nix apps or docks disappearing or privacy apps -- <https://github.com/hraban/mac-app-util>

This will install nix-darwin if you don't already have it.

TODO: want to write a blog post on nix and home-manager. Explaining things but also ranting/reviewing. This is nice: <https://gvolpe.com/blog/home-manager-dotfiles-management/>

```bash
# Move the installer's nix config aside so nix-darwin can own /etc/nix:
sudo mv -n /etc/nix/nix.conf{,.before-nix-darwin} 2>/dev/null || true
sudo mv -n /etc/nix/nix.custom.conf{,.before-nix-darwin} 2>/dev/null || true

sudo --preserve-env=PATH env PATH="$PATH" \
  NIX_CONFIG='extra-experimental-features = nix-command flakes' \
  nix --extra-experimental-features 'nix-command flakes' \
  run 'github:LnL7/nix-darwin/nix-darwin-25.11#darwin-rebuild' -- \
  switch --flake ~/.config/nix-config#gatty --impure --show-trace
```

Three things that command gets right and are easy to get wrong:

- **`--extra-experimental-features` before `run`.** Under `sudo`, nix doesn't
  read your `~/.config/nix/nix.conf` (`$HOME` isn't yours, so it falls back to
  `/var/root`), and `/etc/nix/nix.conf` has just been moved aside — so nothing
  enables `nix-command`/`flakes` for root and you get *"experimental Lix feature
  'nix-command' is disabled"*. The flag has to go to `nix`, before the
  subcommand: anything after the `--` is handed to `darwin-rebuild`, which
  doesn't accept it. (`--enable-experimental-features` isn't a flag at all.)
  `NIX_CONFIG` additionally covers the nested `nix` calls `darwin-rebuild` spawns.
- **`#gatty`.** Without it, `darwin-rebuild` looks for
  `darwinConfigurations.<hostname>`; the configs here are `gatty`, `work` and
  `server`.
- **the pinned `github:LnL7/nix-darwin/nix-darwin-25.11`** rather than the
  `nix-darwin` registry alias, which resolves to whatever is current and may not
  match this flake's inputs.

To do a faster install once set up

```bash
# Equivalent to sudo darwin-rebuild switch --flake ~/.config/nix-config --impure
rebuild
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
- Look into <https://github.com/nix-community/nix-init#configuration>
- Fix thunderbird setup. Keeps asking for password on my accounts
- use git-hooks to manage quality of this repo <https://github.com/cachix/git-hooks.nix>
- Clone another one of those nixos configuration setups, in particular the NixOS VM on mac one.
- TODO: Also put this into some kind of better template
- TODO: Make declarative dock <https://github.com/dustinlyons/nixos-config/blob/8a14e1f0da074b3f9060e8c822164d922bfeec29/modules/darwin/home-manager.nix#L74>
- TODO: Understand <https://github.com/cpick/nix-rosetta-builder>
- TODO: Find material icons nerd font for eza and such.
- TODO: Eventually make pure (using references to my assets dir)
- TODO: learn how to manage ssh keys in nix
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
- Firefox: Disable all autofill for firefox
- [Privacy & Security] Give VSCode and Ghostty access to modify apps on my mac
- [VSCode] Prevent the stupid settings update every single time.
- Make a [claude.md](http://claude.md) and claude settings for projects
- Add color highlight for vscode(?)

## Claude-Code Specific TODOs

check out <https://claudelog.com/configuration/>

Add claude code to vscode extensions

TODO: add keybinds
Installed Cursor terminal Shift+Enter key binding
     See /Users/gat/Library/Application Support/Cursor/User/keybindings.json!

TODO: claude code plugins?

TODO: Configure an askpass??

<https://github.com/hesreallyhim/awesome-claude-code>

TODO: look into <https://github.com/dyoshikawa/rulesync>

<https://github.com/NeoLabHQ/context-engineering-kit>

<https://github.com/Haleclipse/CCometixLine>

<https://github.com/diet103/claude-code-infrastructure-showcase/tree/main>

<https://github.com/disler/just-prompt/tree/main/.claude/commands>

<https://github.com/GWUDCAP/cc-sessions>

<https://github.com/davila7/claude-code-templates>

SUPER COOL:
<https://github.com/SuperClaude-Org/SuperClaude_Framework>

<https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor>

<https://github.com/ruvnet/claude-code-flow>

(so many more orchestrators)

<https://github.com/sirmalloc/ccstatusline>

<https://github.com/nizos/tdd-guard>

<https://github.com/evmts/tevm-monorepo/blob/main/.claude/commands/commit.md>

<https://github.com/liam-hq/liam/blob/main/.claude/commands/create-pull-request.md>

<https://github.com/metabase/metabase/blob/master/.claude/commands/fix-issue.md>

<https://github.com/metabase/metabase/blob/master/.claude/commands/fix-pr.md>

<https://github.com/scopecraft/command/blob/main/.claude/commands/create-command.md>

<https://github.com/spylang/spy/blob/main/CLAUDE.md>

<https://github.com/badass-courses/course-builder/blob/main/CLAUDE.md>

<https://github.com/eastlondoner/cursor-tools/blob/main/CLAUDE.md>

<https://github.com/soramimi/Guitar/blob/master/CLAUDE.md>

<https://github.com/basicmachines-co/basic-memory/blob/main/CLAUDE.md>

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
# Initial installation: see "Fresh install (new machine)" at the top — the bare
#   `sudo nix run nix-darwin -- switch --flake ~/.config/nix-config` is not
#   enough (no experimental features under sudo, no `#gatty` attribute).
# Subsequent updates: darwin-rebuild switch --flake ~/.config/nix-config
#
# nix-darwin: https://nix-darwin.github.io/nix-darwin/manual/index.html
# home-manager: https://nix-community.github.io/home-manager/options.xhtml
```

## Mutability

Good notes on this, also describing issues: <https://discourse.nixos.org/t/strategies-for-declarative-approaches-to-programs-with-mutable-configuration-files/66276>

- Simple patch: <https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa?permalink_comment_id=5027190>

- Include option also nice, but not always present.

## Build Stats

`sudo darwin-rebuild switch --flake ~/.config/nix-config --impure`

- Everything enabled: 1m14s (But goes up to like 2m4s)
- Disable homebrew: 1m52s (cool did not help, went up to, reran and took, 1m 45s so not much better)

```bash
uv tool install --python 3.13 "hawk[cli,inspect] @ git+https://github.com/METR/inspect-action"
```

### Docs to Index in Cursor

- <https://inspect.aisi.org.uk/>
uv python install 3.12 --default
'<https://apps.apple.com/us/app/xcode/id497799835?mt=12>' -- xcode

## Fixing Errors

### nix-daemon: `Connection refused`

If a rebuild fails with `cannot connect to socket at
'/nix/var/nix/daemon-socket/socket': Connection refused`, the nix-daemon isn't
running. Just run:

```bash
sudo ./fix-nix-daemon.sh
```

It bootstraps and restarts the daemon (and tells you to run `./fix-nix-mount.sh`
first if the `/nix` store volume is unmounted). Equivalent manual steps:

```bash
# First, ensure any existing service is unloaded
sudo launchctl bootout system/org.nixos.nix-daemon 2>/dev/null || true

# Then bootstrap (load) the daemon
sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist

# Start/restart the daemon
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```
