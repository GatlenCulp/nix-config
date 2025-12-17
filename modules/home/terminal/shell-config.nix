{ pkgs, secrets }:
let
  sharedShellInit = ''
    # TODO: Convert to use LastPass
    # TODO: Convert to use the envvars nix api
    export EDITOR=cursor
    export PAGER='ov -F'
    export PSQL_PAGER='ov -F -C -d "|" -H1 --column-rainbow --align'
    export MANPAGER="ov --section-delimiter '^[^\s]' --section-header"


    ### API KEYS FROM secrets.nix
    # AI API KEYS
    export OPENAI_API_KEY="${secrets.apiKeys.openai}"
    export ANTHROPIC_API_KEY="${secrets.apiKeys.anthropic}"
    export GEMINI_API_KEY="${secrets.apiKeys.gemini}"

    # OTHER API KEYS
    export UV_PUBLISH_TOKEN="${secrets.apiKeys.pypi-token}"
    export HUGGING_FACE_HUB_TOKEN="${secrets.apiKeys.huggingface}"
    # export GITHUB_TOKEN="${secrets.apiKeys.github}"

    ### AWS
    # No longer needed I believe since I have saved to the AWS config/credentials.
    # export AWS_DEFAULT_REGION="${secrets.awscli.settings.default.region}"
    # export AWS_ACCESS_KEY_ID="${secrets.awscli.credentials.default.aws_access_key_id}"
    # export AWS_SECRET_ACCESS_KEY="${secrets.awscli.credentials.default.aws_secret_access_key}"
    export AWS_PROFILE="${secrets.awscli.defaultProfileOverrideName}"

    ### MIT
    export CSAIL_USERNAME=${secrets.csailUsername}

    ### COOKIECUTTER
    # TODO: Update to use dynamic xdg config
    export COOKIECUTTER_CONFIG="/Users/gat/.config/nix-darwin/assets/gatlen-cookiecutter-config.yaml"

    ### AWS COMPLETION (perhaps future plugin, not on prezto)
    autoload -U bashcompinit && bashcompinit
    complete -C ${pkgs.awscli}/bin/aws_completer aws

    ### FAST FETCH
    fastfetch
  '';
in
# TODO: fix bat caching
{
  bash = {
    enable = true;
    enableCompletion = true;
    initExtra = sharedShellInit;
  };

  zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    enableVteIntegration = true; # Don't fully understand, will learn.
    # defaultKeymap = "viins"; # not necessary with prezto
    syntaxHighlighting.enable = true;
    # cdpath lets you cd to subdirectories of these paths from anywhere
    cdpath = [
      "~"
      "~/projects"
      "~/.config"
    ];
    initContent = sharedShellInit;
    prezto = {
      enable = true;
      python.virtualenvAutoSwitch = true;
      utility.safeOps = true;
      ssh.identities = [ "id_ed25519" ];
      editor.keymap = "vi"; # Enable vi mode through Prezto
    };
  };

  nushell.enable = true;
  fish = {
    enable = true;
  };
}
