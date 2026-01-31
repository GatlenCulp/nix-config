{ pkgs, config, ... }:
with config.sops.secrets;
{
  sharedShellInit = {
    text = ''
      ### PATH FIX: Add nix-darwin system packages
      # /run/current-system doesn't exist on macOS, use direct profile path
      export PATH="/nix/var/nix/profiles/system/sw/bin:$PATH"

      ### AWS COMPLETION (perhaps future plugin, not on prezto)
      autoload -U bashcompinit && bashcompinit
      complete -C ${pkgs.awscli}/bin/aws_completer aws

      ### Nix Darwin since it doesn't always start up
      # sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
      # sudo launchctl kickstart -k system/org.nixos.nix-daemon

      ### FAST FETCH
      fastfetch
    '';
  };
}
