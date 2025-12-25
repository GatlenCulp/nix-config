{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "GatlenCulp@gmail.com";
        name = "Gatlen Culp";
      };
      ui = {
        default-command = "log";
      };
      snapshot = {
        max-new-file-size = "5MiB";
      };
      # Perhaps may want to add pager?
    };
  };
}
