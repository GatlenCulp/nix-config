{ pkgs, config, lib, host, ... }:
{

  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  home.packages = with pkgs; [
      bfg-repo-cleaner
      check-jsonschema
      commitizen
      # cz-cli
      dvc-with-remotes
      git-credential-manager
      git-filter-repo
      git-lfs
      gitkraken
      gitleaks
  ];

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
      # Per-host commit identity (see the `host.git` spec in hosts/*.nix).
      user = {
        email = host.git.email;
        name = host.git.name;
      };

      push.autoSetupRemote = "true";
      pull.rebase = true;
      log.date = "iso"; # use iso format for date

      # Replace https with ssh, and route each GitHub owner to the ssh host
      # alias that pins the right key (see the github blocks in home/ssh).
      #
      # These are prefix rewrites applied at connect time only -- `git remote -v`
      # still shows whatever URL was cloned, so remotes stay portable and repos
      # cloned by `gh` on either machine authenticate as the right account with
      # no per-repo setup.
      url = {
        # Personal account: github.com already defaults to the personal key.
        "ssh://git@github.com/GatlenCulp" = {
          insteadOf = "https://github.com/GatlenCulp";
        };

        # Work org: force these through the alias carrying the work key,
        # whichever form the remote was cloned in.
        "ssh://git@github-civai/civicai" = {
          insteadOf = [
            "https://github.com/civicai"
            "ssh://git@github.com/civicai"
            "git@github.com:civicai"
          ];
        };

        # Work account's own (non-org) repos.
        "ssh://git@github-civai/Gatlen-CivAI" = {
          insteadOf = [
            "https://github.com/Gatlen-CivAI"
            "ssh://git@github.com/Gatlen-CivAI"
            "git@github.com:Gatlen-CivAI"
          ];
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
