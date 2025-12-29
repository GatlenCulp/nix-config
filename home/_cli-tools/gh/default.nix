{
  # gitCredentialHelper.enable = true;
  # hosts = {
  #   "github.com" = { user = "GatlenCulp"; };
  #   settings = { git_protocol = "ssh"; };
  # };
  programs.gh = {
    enable = true;
  # Let this be managed by gh auth login
  #   settings = { 
  #     git_protocol = "ssh";
  #     prompt = "enabled";
  #   };
  #   # Don't fully understand this setup
  #   hosts = {
  #     "github.com" = {
  #       "users" = {
  #         "GatlenCulp" = null;
  #       };
  #       "user" = "GatlenCulp";
  #     };
  #   };
  };
}
