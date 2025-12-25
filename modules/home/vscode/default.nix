{ pkgs, self, ... }:
{
  programs.vscode = {
    enable = true;
    # enableMcpIntegration = true; # Error?
    profiles.default = {
      extensions = import ./vscode-extensions.nix { inherit pkgs; };
      userSettings = import ./vscode-settings.nix { inherit self; };
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
