{
  # config,
  ...
}:
{
  programs.zsh = {
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
    # initContent = sharedShellInit;
    prezto = {
      enable = true;
      python.virtualenvAutoSwitch = true;
      utility.safeOps = true;
      ssh.identities = [ "id_ed25519" ];
      editor.keymap = "vi"; # Enable vi mode through Prezto
    };
    # dotDir = "${config.xdg.configHome}/zsh";
    dotDir = "Users/gat/.config/zsh"; # TODO: Change to above later
  };
}
