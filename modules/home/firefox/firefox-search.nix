{ pkgs, ... }:
{
  engines = {
    nix-packages = {
      name = "Nix Packages";
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };

    nixos-wiki = {
      name = "NixOS Wiki";
      urls = [
        {
          template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
        }
      ];
      iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
      definedAliases = [ "@nw" ];
    };
    my-nixos = {
      name = "MyNixOS";
      urls = [
        {
          template = "https://mynixos.com/search?q={searchTerms}";
        }
      ];
      iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
      definedAliases = [ "@mynixos" ];
    };
    nix-home-manager = {
      name = "Nix Home Manager Option Search";
      urls = [
        {
          template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=release-25.11";
        }
      ];
      definedAliases = [ "@hm" ];
    };

    youtube = {
      name = "YouTube";
      urls = [
        {
          template = "https://www.youtube.com/results?search_query={searchTerms}";
        }
      ];
      definedAliases = [ "@yt" ];
    };

    nixvim = {
      name = "Nixvim Options Search";
      urls = [
        {
          template = "https://nix-community.github.io/nixvim/search/?query={searchTerms}";
        }
      ];
      definedAliases = [ "@nv" ];
    };

    perplexity = {
      name = "Perplexity";
      urls = [ { template = "https://www.perplexity.ai/search?q={searchTerms}"; } ];
      definedAlias = [ "@p" ];
    };

    google-maps = {
      name = "Google Maps";
      urls = [ { template = "https://www.google.com/maps/search/?api=1&{searchTerms}"; } ];
      definedAlias = [ "@maps" ];
    };

    github = {
      name = "GitHub";
      urls = [ { template = "https://github.com/search?type=repositories&q={searchTerms}"; } ];
      definedAlias = [ "@gh" ];
    };

    bing.metaData.hidden = true;
    google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
  };
}
