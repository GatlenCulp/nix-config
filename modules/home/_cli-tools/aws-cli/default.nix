{ secrets, ... }:
{
  programs.awscli = {
    enable = true;
    settings = secrets.awscli.settings;
    credentials = secrets.awscli.credentials;
  };
}
