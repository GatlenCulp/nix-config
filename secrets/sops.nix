# secrets/sops.nix
#
# sops-nix wiring, parameterized per machine via the `host.sops` spec (see
# hosts/base.nix). This keeps the decryption identity and encrypted-file path
# machine-specific so a work laptop can be pointed at a work-only secrets file
# with its own age key, without touching this module.
#
# The whole wiring is *optional*: it only activates when the age decryption key
# actually exists on the machine, or when a host explicitly sets
# `host.sops.enable`. A freshly-provisioned machine that hasn't had its key
# restored yet — or one that simply doesn't use sops — then rebuilds cleanly
# instead of failing when sops-nix tries to decrypt during activation. Consumers
# of config.sops.secrets.* must apply the same guard (see home/shells), since
# these secrets are undefined when sops is off.
{ host, lib, ... }:
let
  # Explicit opt-in/out wins; otherwise auto-detect from the age key's presence.
  sopsEnabled = host.sops.enable or (builtins.pathExists host.sops.ageKeyFile);
in
{
  sops = lib.mkIf sopsEnabled {
    age.keyFile = host.sops.ageKeyFile;
    defaultSopsFile = host.sops.sopsFile;
    defaultSymlinkPath = host.sops.symlinkPath;
    defaultSecretsMountPoint = host.sops.mountPoint;
    # config.sops.secrets.OPENAI_API_KEY.path points to a runtime-generated decrypted file. nix-darwin: Usually /run/secrets-for-users/<username>/OPENAI_API_KEY or similar
    secrets = {
      "OPENAI_API_KEY" = { };
      "ANTHROPIC_API_KEY" = { };
      "GEMINI_API_KEY" = { };
      "UV_PUBLISH_TOKEN" = { };
      "HUGGING_FACE_HUB_TOKEN" = { };
      "GATLEN_PERSONAL_RUNPOD_API_KEY" = { };
      "CSAIL_USERNAME" = { };

      # AWS
      "aws/credentials/default/aws_access_key_id" = { };
      "aws/credentials/default/aws_secret_access_key" = { };
      "aws/settings/default/region" = { };
      # "AWS_PROFILE" = { };
    };

  };
}
