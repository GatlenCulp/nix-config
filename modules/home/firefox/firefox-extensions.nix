{ pkgs }:
{
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
        material-icons-for-github
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

    }
