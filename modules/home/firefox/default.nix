{ pkgs, ... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs.firefox = {
    # Good guide:
    enable = true;
    languagePacks = [ "en-US" ];
    policies = {
      # See https://mozilla.github.io/policy-templates/
      # BlockAboutConfig = true;
      DefaultDownloadDirectory = "\${home}/Downloads";
      PictureInPicture = "enabled";

    };
    profiles.default = {
      isDefault = true;
      name = "Gatlen";

      extensions = import ./firefox-extensions.nix { inherit pkgs; };
      search = import ./firefox-search.nix { inherit pkgs; };

      settings = {
        # In firefox, see about:config
        # Also helpful: https://support.mozilla.org/en-US/products/firefox/settings
        "browser.startup.homepage" = "https://dormsoup.mit.edu";
        "browser.formfill.enable" = lock-false;
        "browser.showMobileBookmarks" = false;
        "browser.toolbars.bookmarks.visibility" = "Only Show on New Tab";
        "services.sync.username" = "culpdesigns2@gmail.com";
        "sidebar.visibility" = "hide-sidebar";

        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" = lock-true;
        # {"placements":{"widget-overflow-fixed-list":["firefox-view-button"],"unified-extensions-area":["_2662ff67-b302-4363-95f3-b050218bd72c_-browser-action","_85860b32-02a8-431a-b2b1-40fbd64c9c69_-browser-action","_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action","_7be2ba16-0f1e-4d93-9ebc-5164397477a9_-browser-action","zotero_chnm_gmu_edu-browser-action"],"nav-bar":["sidebar-button","back-button","forward-button","stop-reload-button","home-button","vertical-spacer","urlbar-container","downloads-button","fxa-toolbar-menu-button","unified-extensions-button","support_lastpass_com-browser-action","ublock0_raymondhill_net-browser-action"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"vertical-tabs":[],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button","screenshot-button","_2662ff67-b302-4363-95f3-b050218bd72c_-browser-action","_85860b32-02a8-431a-b2b1-40fbd64c9c69_-browser-action","support_lastpass_com-browser-action","_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action","_7be2ba16-0f1e-4d93-9ebc-5164397477a9_-browser-action","zotero_chnm_gmu_edu-browser-action","ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","vertical-tabs","PersonalToolbar","unified-extensions-area","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":23,"newElementCount":3}
      };
    };
  };
}
