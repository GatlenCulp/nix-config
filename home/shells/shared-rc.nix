{ pkgs, config, ... }:
with config.sops.secrets;
{
  sharedShellInit = {
    text = ''
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
