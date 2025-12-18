{ pkgs }:
{
  enable = true;
  languagePacks = [ "en-US" ];
  policies = {
    BlockAboutConfig = true;
    DefaultDownloadDirectory = "\${home}/Downloads";
  };
  profiles.default = {
    isDefault = true;
    name = "Gatlen";

    extensions = {
      force = true;
      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        # Youtube/Video
        unpaywall
        videospeed
        tweaks-for-youtube
        untrap-for-youtube
        watchmarker-for-youtube
        theater-mode-for-youtube
        return-youtube-dislikes
        # Github
        refined-github
        gitako-github-file-tree
        github-file-icons
        github-isometric-contributions
        # Misc
        ublock-origin
        lastpass-password-manager
        proton-vpn
        link-cleaner
        zotero-connector
      ];
      # settings."uBlock0@raymondhill.net".force = true;
      settings."uBlock0@raymondhill.net".settings = {
        enable = true;
        selectedFilterLists = [
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
        ];
      };
    };

    search.engines = {
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

      bing.metaData.hidden = true;
      google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
    };

    settings = {
      "browser.startup.homepage" = "https://dormsoup.mit.edu";
    };
  };
}
