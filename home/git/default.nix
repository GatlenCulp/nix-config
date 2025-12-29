{ config, lib, ... }:
{

  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  # Development Tools
  programs.git = {
    # Helpful ref: https://gist.github.com/pksunkara/988716
    enable = true;
    ignores = [
      "**/.DS_Store"
      "**/__pycache__/"
      "**/.ruff_cache/"
      "**/.mypy_cache/"
      "**/.env"
      "**/.venv"
      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"
      "*.swp"
      "*.swo"
      "*~"
      "ehthumbs.db"
      "Icon?"
      "Thumbs.db"
    ];
    lfs.enable = true;
    # includes = [
    #   {
    #     # use different email & name for work:
    #     #
    #     # [user]
    #     #   email = "xxx@xxx.com"
    #     #   name = "Ryan Yin"
    #     path = "~/work/.gitconfig";
    #     condition = "gitdir:~/work/";
    #   }
    # ];
    settings = {
      # https://noborus.github.io/ov/delta/index.html
      # core = {
      #   pager = "delta --pager='ov -F'"; # set by programs.delta
      # };
      init = {
        defaultBranch = "main";
        # https://pre-commit.com/#automatically-enabling-pre-commit-on-repositories
        # TODO: Write the ~/.git-template dir using nix
        templateDir = "~/.git-template";
      };
      # pager = {
      #   diff = "delta --features ov-diff";
      #   log = "delta --features ov-log";
      #   show = "delta --pager='ov -F --header 3'";
      # };
      user = {
        email = "GatlenCulp@gmail.com";
        name = "GatlenCulp";
      };

      push.autoSetupRemote = "true";
      pull.rebase = true;
      log.date = "iso"; # use iso format for date

      # replace https with ssh
      url = {
        "ssh://git@github.com/GatlenCulp" = {
          insteadOf = "https://github.com/GatlenCulp";
        };
      };

      aliases = {
        # common aliases
        br = "branch";
        co = "checkout";
        st = "status";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        cm = "commit -m"; # commit via `git cm <message>`
        ca = "commit -am"; # commit all changes via `git ca <message>`
        dc = "diff --cached";

        amend = "commit --amend -m"; # amend commit message via `git amend <message>`
        unstage = "reset HEAD --"; # unstage file via `git unstage <file>`
        merged = "branch --merged"; # list merged(into HEAD) branches via `git merged`
        unmerged = "branch --no-merged"; # list unmerged(into HEAD) branches via `git unmerged`
        nonexist = "remote prune origin --dry-run"; # list non-exist(remote) branches via `git nonexist`

        # delete merged branches except master & dev & staging
        #  `!` indicates it's a shell script, not a git subcommand
        delmerged = ''! git branch --merged | egrep -v "(^\*|main|master|dev|staging)" | xargs git branch -d'';
        # delete non-exist(remote) branches
        delnonexist = "remote prune origin";

        # aliases for submodule
        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };
    };
  };

  # Git terminal UI (written in go).
  programs.lazygit.enable = true;

  # Yet another Git TUI (written in rust).
  programs.gitui.enable = false;
}
