{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  programs.himalaya = {
    enable = true;
    # package = pkgs.himalaya.override { withNotmuchBackend = true; };
  };
}
