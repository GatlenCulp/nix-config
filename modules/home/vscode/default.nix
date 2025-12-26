{ pkgs, self, config, ... }:
{
  programs.vscode = {
    enable = true;
    # enableMcpIntegration = true; # Error?
    mutableExtensionsDir = true;
    profiles.default = {
      extensions = import ./vscode-extensions.nix { inherit pkgs; };
      userSettings = import ./vscode-settings.nix { inherit self config; };
      keybindings = [
        {
          key = "cmd+l";
          command = "claude-vscode.insertAtMention";
          when = "editorTextFocus";
        }
      ];
    };
  };
}
