{
  pkgs,
  config,
  lib,
  ...
}:
{
  # # Configure sops to decrypt AWS files (INI format with inline encryption)
  # # Extract the individual secrets from the INI files
  # sops.secrets."aws-credentials/default/aws_access_key_id" = {
  #   sopsFile = ../../../secrets/aws-credentials.ini;
  #   format = "ini";
  # };

  # sops.secrets."aws-credentials/default/aws_secret_access_key" = {
  #   sopsFile = ../../../secrets/aws-credentials.ini;
  #   format = "ini";
  # };

  # sops.secrets."aws-config/default/region" = {
  #   sopsFile = ../../../secrets/aws-config.ini;
  #   format = "ini";
  # };

  # # Use templates to reconstruct the INI files from individual secrets
  # sops.templates."aws-credentials" = {
  #   content = ''
  #     [default]
  #     aws_access_key_id = ${config.sops.placeholder."aws-credentials/default/aws_access_key_id"}
  #     aws_secret_access_key = ${config.sops.placeholder."aws-credentials/default/aws_secret_access_key"}
  #   '';
  #   path = "${config.home.homeDirectory}/.aws/credentials";
  #   mode = "0600";
  # };

  # sops.templates."aws-config" = {
  #   content = ''
  #     [default]
  #     region = ${config.sops.placeholder."aws-config/default/region"}
  #     output = json
  #   '';
  #   path = "${config.home.homeDirectory}/.aws/config";
  #   mode = "0600";
  # };

  # Enable AWS CLI
  programs.awscli.enable = true;
  # I'll just manually do the config for now.
}
