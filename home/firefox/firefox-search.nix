{ pkgs, ... }:
{
  engines = {
    nix-packages = {
      name = "Nix Packages";
      urls = [
        {
          template = "https://search.nixos.org";
          # Oh you don't really need to write out the params in the url oops, only if in path.
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

    noogle = {
      name = "Noogle";
      urls = [
        {
          template = "https://noogle.dev/q?term={searchTerms}";
        }
      ];
      definedAliases = [ "@noogle" ];
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

    tldr = {
      name = "TLDR Pages";
      urls = [ { template = "https://tldr.inbrowser.app/pages/common/{searchTerms}"; } ];
      definedAlias = [ "@tldr" ];
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

# Chrome search engine import format (name, shortcut, url):
# Nix Packages
# @np
# https://search.nixos.org?type=packages&query=%s
#
# NixOS Wiki
# @nw
# https://wiki.nixos.org/w/index.php?search=%s
#
# Noogle
# @noogle
# https://noogle.dev/q?term=%s
#
# MyNixOS
# @mynixos
# https://mynixos.com/search?q=%s
#
# Nix Home Manager Option Search
# @hm
# https://home-manager-options.extranix.com/?query=%s&release=release-25.11
#
# YouTube
# @yt
# https://www.youtube.com/results?search_query=%s
#
# Nixvim Options Search
# @nv
# https://nix-community.github.io/nixvim/search/?query=%s
#
# Perplexity
# @p
# https://www.perplexity.ai/search?q=%s
#
# TLDR Pages
# @tldr
# https://tldr.inbrowser.app/pages/common/%s
#
# Google Maps
# @maps
# https://www.google.com/maps/search/?api=1&%s
#
# GitHub
# @gh
# https://github.com/search?type=repositories&q=%s
