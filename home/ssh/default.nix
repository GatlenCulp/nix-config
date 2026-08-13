{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };

    extraConfig = ''
      Include ~/.ssh/align.ssh
      Include ~/.ssh/metr.ssh
      Include ~/.ssh/extra.ssh
    '';

    matchBlocks = {
      # ── GitHub: two accounts, one config ──────────────────────────────────
      #
      # Both keys are registered on every machine; which one is used is decided
      # by the repo, not the host. `home/git` rewrites remote URLs by owner so
      # this is automatic -- GatlenCulp/* resolves to `github.com` and civicai/*
      # to `github-civai`. Nothing to remember at push time.
      #
      # Each block MUST name an `identityFile`. `identitiesOnly` alone narrows
      # nothing: ssh still offers every key loaded in the agent and GitHub
      # authenticates as whichever it accepts first. With both accounts' keys in
      # the agent that silently picks the wrong one, which surfaces as
      # "Permission to GatlenCulp/<repo> denied to Gatlen-CivAI".
      #
      # Naming an identityFile also means the agent is not consulted at all, so
      # `ssh-add` order stops mattering.

      # Personal account (GatlenCulp). The default for github.com.
      "github.com" = {
        # "Using SSH over the HTTPS port for GitHub"
        # "(port 22 is banned by some proxies / firewalls)"
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
        identityFile = "~/.ssh/gatlen-personal";
        identitiesOnly = true;
      };

      # Work account (Gatlen-CivAI). Not a real hostname -- an alias that pins
      # the work key; `hostname` below points it at the same GitHub endpoint.
      "github-civai" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

      "192.168.*" = {
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "romantic holds my homelab~"
        # identityFile = "/etc/agenix/ssh-key-romantic";
        identitiesOnly = true;
      };
    };
  };
}
