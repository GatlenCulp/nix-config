{
  sops = {
    age.keyFile = "/Users/gat/.config/sops/age/keys-nix-sops.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSymlinkPath = "/Users/gat/.config/sops-nix/secrets";
    defaultSecretsMountPoint = "/Users/gat/.config/sops-nix/secrets.d";
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
