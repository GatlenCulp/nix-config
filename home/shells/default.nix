# nushell lacks native nix-darwin support for managing /etc/shells and environment setup, so direct chsh -s nu drops Nix vars and Home-Manager configs. The exec nu workaround in zsh (via initExtra) reliably propagates everything while keeping configs declarative.
{
  pkgs,
  secrets,
  lib,
  config,
  ...
}:
let
  sharedShellInitData = import ./shared-rc.nix {
    inherit pkgs config;
  };
  sharedShellInit = sharedShellInitData.sharedShellInit;
  zshConfig = import ./zsh.nix { inherit config; };
  bashConfig = import ./bash.nix;
  fishConfig = import ./fish.nix;
  nushellConfig = import ./nushell.nix { inherit lib pkgs; };
  xonshConfig = import ./xonsh.nix { inherit pkgs; };
in
lib.mkMerge [
  zshConfig
  bashConfig
  fishConfig
  nushellConfig
  xonshConfig
  {
    programs.zsh = {
      # Not recommended to use nushell as a login shell https://wiki.nixos.org/wiki/Nushell
      # This extra bit is annoying, recommend setting an initialization command in vscode / ghostty / whatever other terminal instead to switch to nushell
      initContent = sharedShellInit.text
      # + ''
      #   # Only exec nu in interactive shells
      #   if [[ -o interactive ]] && [[ "$TERM" != "dumb" ]]; then
      #     exec nu
      #   fi
      # ''
      ;
    };
    programs.bash = {
      initExtra = sharedShellInit.text
      # + ''
      #   # Only exec nu in interactive shells
      #   if [[ $- == *i* ]] && [ "$TERM" != "dumb" ]; then
      #     exec nu
      #   fi
      # ''
      ;
    };

    home.packages = with pkgs; [
      bashate
      powershell
      shellcheck
      shfmt
    ];

    home.sessionVariables = {
      # Locale settings (must be set early)
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";

      # General environment
      EDITOR = "vim";
      VISUAL = "code";
      PAGER = "ov -F";
      PSQL_PAGER = "ov -F -C -d | -H1 --column-rainbow --align";
      MANPAGER = "ov --section-delimiter '^[^\s]' --section-header";
      SOPS_AGE_KEY_FILE = "${config.xdg.configHome}/sops/age/keys-nix-sops.txt";

      ### API KEYS FROM SOPS
      # AI API KEYS
      OPENAI_API_KEY = "$(cat ${config.sops.secrets.OPENAI_API_KEY.path})";
      ANTHROPIC_API_KEY = "$(cat ${config.sops.secrets.ANTHROPIC_API_KEY.path})";
      GEMINI_API_KEY = "$(cat ${config.sops.secrets.GEMINI_API_KEY.path})";

      # OTHER API KEYS
      UV_PUBLISH_TOKEN = "$(cat ${config.sops.secrets.UV_PUBLISH_TOKEN.path})";
      HUGGING_FACE_HUB_TOKEN = "$(cat ${config.sops.secrets.HUGGING_FACE_HUB_TOKEN.path})";
      # export GITHUB_TOKEN=""

      ### AWS
      # Managed by awscli module, only export profile override if needed
      # export AWS_PROFILE=""

      ### MIT
      CSAIL_USERNAME = "$(cat ${config.sops.secrets.CSAIL_USERNAME.path})";

      ### COOKIECUTTER
      COOKIECUTTER_CONFIG = "${config.xdg.configHome}/nix-config/assets/gatlen-cookiecutter-config.yaml";

      edit_config = "$EDITOR ~/.config/nix-config";
      rebuild = "NIXPKGS_ALLOW_UNFREE=1 sudo darwin-rebuild switch --flake .#gatty ~/.config/nix-config --show-trace --impure";
      lsr = "eza -T --git-ignore";
    };
  }
]
