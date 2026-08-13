{
  description = "Gatlen's nix-darwin macOS nix configuration";

  inputs = {
    nixpkgs-stable-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs.follows = "nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable-darwin";
    };
    home-manager = {
      # Must match the nixpkgs release used for the system (25.11) because
      # useGlobalPkgs = true makes HM evaluate against nix-darwin's pkgs.
      # master/unstable HM imports lib/services/lib.nix which only exists in
      # nixpkgs-unstable, breaking eval against the 25.11 stable pkgs.
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable-darwin";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    # nix-rosetta-builder = {
    #   url = "github:cpick/nix-rosetta-builder";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    # nixvim/nvix retired: neovim is now a plain lazy.nvim config in
    # home/nvim (old module preserved in home/_legacy/nvim-nixvim).
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   # Recommends not using following
    # };

    # nvix = {
    #   # url = "github:GatlenCulp/nvix";
    #   url = "git+file:/Users/gat/nix/nvix";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    nix-gat-vscode = {
      # url = "github:GatlenCulp/nix-gat-vscode";
      url = "git+file:/Users/gat/nix/nix-gat-vscode";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
    };

    nix-openclaw = {
      url = "github:openclaw/nix-openclaw"; # pins macOS app + gateway bundle
    };

    # Claude Code straight from Anthropic's release CDN, re-pinned hourly by CI.
    # nixpkgs' `claude-code` trails upstream by weeks (PR review + channel lag),
    # which strands us many versions behind; this flake's package.nix is just a
    # sha256-pinned fetchurl of the same official native binary plus a wrapper,
    # so it is the identical artifact, only fresher. Consumed in
    # home/claude-code (NOT as an overlay) so that module stays the single
    # provider of `claude` on PATH -- see the note in home/nvim/default.nix.
    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      # nix-vscode-extensions,
      # nur, # input is commented out above; destructuring it would break eval
      # nixvim/nvix retired (see inputs above); neovim lives in home/nvim now.
      nix-homebrew,
      sops-nix,
      nix-gat-vscode,
      zjstatus,
      nix-openclaw,
      claude-code-nix,
      ...
    }:
    let
      # Inputs every host module needs. Each host file (hosts/*.nix) builds its
      # own `host` spec and imports hosts/base.nix with these.
      hostInputs = {
        inherit
          self
          nix-darwin
          home-manager
          nix-homebrew
          sops-nix
          nix-gat-vscode
          claude-code-nix
          ;
      };

      # A host file now returns a darwin module directly (via hosts/base.nix),
      # so a machine is a one-liner: mkHost ./hosts/<name>.nix
      mkHost = hostFile: nix-darwin.lib.darwinSystem {
        modules = [ (import hostFile hostInputs) ];
      };

      lib = inputs.nixpkgs.lib;
    in
    {
      # Evaluation tests for the machine-profile split. Run on the Mac with
      # `nix flake check` (the configs are aarch64-darwin + local git+file: inputs).
      checks.aarch64-darwin.machine-profiles = import ./tests/machine-profiles.nix {
        inherit self lib;
        pkgs = import inputs.nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };

      darwinConfigurations = {
        # Personal laptop — full app/tooling set, personal identity + secrets.
        "gatty" = mkHost ./hosts/gatty.nix;

        # Work laptop — curated tooling, work identity, work-only secrets,
        # MDM-safe Homebrew. See hosts/work.nix for the provisioning TODOs.
        "work" = mkHost ./hosts/work.nix;

        # server still uses the older host shape; left untouched for now.
        "server" = nix-darwin.lib.darwinSystem {
          modules = [
            (import ./hosts/server.nix hostInputs).gatty-config
            sops-nix.darwinModules.sops
            # "${self}/modules/darwin/fonts.nix"
            # "${self}/modules/darwin/homebrew.nix"
          ];
        };
      };
    };
}
