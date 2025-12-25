{ pkgs, self, ...}:
{
                enable = true;
                # enableMcpIntegration = true; # Error?
                profiles.default = {
                  extensions = import "${self}/modules/home/vscode/vscode-extensions.nix" {
                    inherit pkgs;
                  };
                  userSettings = import "${self}/modules/home/vscode/vscode-settings.nix";
                  keybindings = [
                  {
                    key = "cmd+l";
                    command = "";
                  }
                  ];
                };
}
