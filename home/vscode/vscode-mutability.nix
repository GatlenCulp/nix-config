# This module makes VS Code config files mutable (editable after generation)
# by replacing the nix-store symlinks with writable copies after home-manager
# creates them.
#
# Unlike using the `mutable` home.file option, this approach doesn't conflict
# with the VS Code module's file definitions since we just run an activation
# script after linkGeneration.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.vscode.profiles.default;
  configDir = "Code";
  userDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/${configDir}/User"
    else
      "${config.xdg.configHome}/${configDir}/User";

  # List of files to make mutable
  filesToMakeMutable = lib.flatten [
    (lib.optional (cfg.userSettings != { }) "${userDir}/settings.json")
    (lib.optional (cfg.keybindings != [ ]) "${userDir}/keybindings.json")
    (lib.optional (cfg.userTasks != { }) "${userDir}/tasks.json")
  ];

  # Generate the shell commands to replace symlinks with copies
  makeFileMutable = file: ''
    target="$HOME/${file}"
    if [ -L "$target" ]; then
      real_source=$(readlink "$target")
      echo "Making mutable: $target"
      rm "$target"
      cp "$real_source" "$target"
      chmod u+w "$target"
    elif [ -f "$target" ]; then
      echo "Already mutable: $target"
    fi
  '';
in
{
  # May need clean up script to remove backup file or enable
  # home.activation.vscodeFileMutability = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
  #   echo "Making VS Code config files mutable..."
  #   ${lib.concatMapStrings makeFileMutable filesToMakeMutable}
  # '';

  # Remove old VSCode config before checkLinkTargets runs
  home.activation."clearVSCodeConfig" = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    echo "=== RUNNING clearVSCodeConfig ==="
    rm -f "/Users/gat/Library/Application Support/Code/User/keybindings.json"
    rm -f "/Users/gat/Library/Application Support/Code/User/keybindings.json.backup"
    rm -f "/Users/gat/Library/Application Support/Code/User/settings.json"
    rm -f "/Users/gat/Library/Application Support/Code/User/settings.json.backup"
    echo "=== DONE clearVSCodeConfig ==="
  '';

  home.activation.vscodeFileMutability = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    echo "Making VS Code config files mutable..."
    ${lib.concatMapStrings makeFileMutable filesToMakeMutable}
  '';
}
