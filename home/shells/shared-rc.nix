{ pkgs, config, ... }:
with config.sops.secrets; {
  sharedShellInit = {
    text = ''
      export EDITOR=vim
      export VISUAL=code
      export PAGER='ov -F'
      export PSQL_PAGER='ov -F -C -d "|" -H1 --column-rainbow --align'
      export MANPAGER="ov --section-delimiter '^[^\s]' --section-header"

      export SOPS_AGE_KEY_FILE="${config.xdg.configHome}/sops/age/keys-nix-sops.txt"

      ### API KEYS FROM SOPS
      # AI API KEYS
      export OPENAI_API_KEY=$(cat ${OPENAI_API_KEY.path})
      export ANTHROPIC_API_KEY=$(cat ${ANTHROPIC_API_KEY.path})
      export GEMINI_API_KEY=$(cat ${GEMINI_API_KEY.path})

      # OTHER API KEYS
      export UV_PUBLISH_TOKEN=$(cat ${UV_PUBLISH_TOKEN.path})
      export HUGGING_FACE_HUB_TOKEN=$(cat ${HUGGING_FACE_HUB_TOKEN.path})
      # export GITHUB_TOKEN=""

      ### AWS
      # Managed by awscli module, only export profile override if needed
      # export AWS_PROFILE=""

      ### MIT
      export CSAIL_USERNAME=$(cat ${CSAIL_USERNAME.path})

      ### COOKIECUTTER
      export COOKIECUTTER_CONFIG="${config.xdg.configHome}/nix-config/assets/gatlen-cookiecutter-config.yaml"

      ### AWS COMPLETION (perhaps future plugin, not on prezto)
      autoload -U bashcompinit && bashcompinit
      complete -C ${pkgs.awscli}/bin/aws_completer aws

      ### FAST FETCH
      fastfetch
    '';
  };
}
