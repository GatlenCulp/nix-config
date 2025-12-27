# TODO: Fix later. AWS doesn't really work :/
# { config, lib, ... }:
# let
#   # Read secrets from sops runtime paths
#   readSecret = secretName: lib.removeSuffix "\n" (builtins.readFile config.sops.secrets.${secretName}.path);
# in
# {
#   home.file.".test-output".source = ''
#     AWS Credentials:

#     ${config.sops.secrets."aws/credentials/default/aws_access_key_id".path}

#     ${readSecret "aws/credentials/default/aws_access_key_id"}
#   '';
#   programs.awscli = {
#     enable = true;

#     # settings = {
#     #   default = {
#     #     region = readSecret "aws/settings/default/region";
#     #     output = "json";
#     #   };
#     # };

#     # credentials = {
#     #   default = {
#     #     aws_access_key_id = readSecret "aws/credentials/default/aws_access_key_id";
#     #     aws_secret_access_key = readSecret "aws/credentials/default/aws_secret_access_key";
#     #   };
#     # };
#   };
# }
{ config, lib, ... }:
# In your home.nix or darwin flake
{
  # Use activation script to render after secrets are available
  home.activation.writeAwsCredentials = lib.hm.dag.entryAfter ["writeBoundary"] ''
    cat > $HOME/.aws/credentials << EOF
    [default]
    aws_access_key_id = $(cat $HOME/.config/sops-nix/secrets/aws/credentials/default/aws_access_key_id)
    aws_secret_access_key = $(cat $HOME/.config/sops-nix/secrets/aws/credentials/default/aws_secret_access_key)
    EOF
  '';

  home.file.".aws/config".text = ''
    [default]
    region = $(cat $HOME/.config/sops-nix/secrets/aws/settings/default/region)
    output = json
  '';

  programs.awscli.enable = true;
}
