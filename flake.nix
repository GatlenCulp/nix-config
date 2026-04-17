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
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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

    nixvim = {
      url = "github:nix-community/nixvim";
      # Recommends not using following
    };

    nvix = {
      # url = "github:GatlenCulp/nvix";
      url = "git+file:/Users/gat/nix/nvix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

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
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      # nix-vscode-extensions,
      nur,
      nixvim,
      nvix,
      nix-homebrew,
      sops-nix,
      nix-gat-vscode,
      zjstatus,
      nix-openclaw,
      ...
    }:
    let
      # gatty-config = import ./hosts/gatty.nix {
      #   # TODO: just pass inputs I guess
      #   # inherit inputs;
      #   inherit self;
      #   inherit nix-darwin;
      #   inherit home-manager;
      #   # inherit nur;
      #   inherit nixvim;
      #   inherit nvix;
      #   inherit nix-homebrew;
      #   inherit sops-nix;
      #   inherit nix-gat-vscode;
      # };
    in
    {
      darwinConfigurations = {
        "gatty" = nix-darwin.lib.darwinSystem {
          modules = [
            (
              import ./hosts/gatty.nix {
              # TODO: just pass inputs I guess
              # inherit inputs;
              inherit self;
              inherit nix-darwin;
              inherit home-manager;
              # inherit nur;
              inherit nixvim;
              inherit nvix;
              inherit nix-homebrew;
              inherit sops-nix;
              inherit nix-gat-vscode;
            }
            ).gatty-config
            sops-nix.darwinModules.sops
            "${self}/modules/darwin/fonts.nix"
            "${self}/modules/darwin/homebrew.nix"
          ];
        };
        "server" = nix-darwin.lib.darwinSystem {
          modules = [
            (
              import ./hosts/server.nix {
              # TODO: just pass inputs I guess
              # inherit inputs;
              inherit self;
              inherit nix-darwin;
              inherit home-manager;
              # inherit nur;
              inherit nixvim;
              inherit nvix;
              inherit nix-homebrew;
              inherit sops-nix;
              inherit nix-gat-vscode;
            }
            ).gatty-config
            sops-nix.darwinModules.sops
            # "${self}/modules/darwin/fonts.nix"
            # "${self}/modules/darwin/homebrew.nix"
          ];
        };
      };
    };
}
