# modules/darwin/homebrew-work.nix
#
# Homebrew for the work laptop. Deliberately conservative so it coexists with
# corporate MDM (Jamf/Kandji/etc.):
#   * cleanup = "none"  -> never uninstall casks/formulae it didn't install, so
#     MDM-pushed apps are left untouched (personal config uses "zap").
#   * autoUpdate / upgrade = false -> no surprise churn during a rebuild.
#
# TODO(work-provisioning): add corp-mandated casks (e.g. slack, zoom, the VPN
# client, an MDM helper) once you know what IT requires — or leave `enable`
# false and let MDM own all GUI apps.
{
  homebrew = {
    enable = false; # flip to true once work casks are decided

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none"; # MDM-safe: do not remove unmanaged apps
    };

    casks = [
      "tailscale-app"
      # "slack"
      # "zoom"
    ];
  };
}
