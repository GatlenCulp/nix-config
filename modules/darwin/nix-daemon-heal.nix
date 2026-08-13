# modules/darwin/nix-daemon-heal.nix
#
# Boot-time healer for the multi-user nix-daemon LaunchDaemon.
#
# Symptom this fixes: after a reboot, org.nixos.nix-daemon occasionally fails
# to come up, so /nix/var/nix/daemon-socket/socket never appears and any nix /
# darwin-rebuild call errors with "Connection refused". This LaunchDaemon runs
# at boot, waits up to 20 s for the socket to bind on its own, and only if it
# doesn't shows up does it re-execute fix-nix-daemon.sh (which boots the
# nix-daemon service out and back in). launchd.daemons.* run as root under
# nix-darwin, which is what the healer needs to touch the system launchd
# domain.
{ pkgs, ... }:
let
  fixScript = ../../fix-nix-daemon.sh;

  runner = pkgs.writeShellScript "nix-daemon-heal-runner" ''
    set -uo pipefail

    socket=/nix/var/nix/daemon-socket/socket

    # If /nix isn't mounted this healer can't do anything -- that's a separate
    # failure mode covered by fix-nix-mount.sh.
    [ -d /nix/store ] || exit 0

    for _ in $(seq 1 20); do
      [ -S "$socket" ] && exit 0
      sleep 1
    done

    exec /bin/bash ${fixScript}
  '';
in
{
  launchd.daemons.nix-daemon-heal = {
    serviceConfig = {
      Label = "org.nixos.nix-daemon-heal";
      ProgramArguments = [ "${runner}" ];
      RunAtLoad = true;
      StandardOutPath = "/var/log/nix-daemon-heal.log";
      StandardErrorPath = "/var/log/nix-daemon-heal.log";
    };
  };
}
