{
  # NOTE: Just for darwin oops.
  system = {
    startup.chime = false;

    defaults = {
      # Dock & App Switcher
      dock = {
        expose-animation-duration = 5.0e-2;
        largesize = 32;
        minimize-to-application = true;
        orientation = "left";
        show-process-indicators = true;
        show-recents = false;
        tilesize = 24;
      };

      # Finder & Files
      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true; # show status bar
      };

      trackpad = {
        Clicking = true; # Enable tap to click
      };

      # Menu Bar
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 0;
      };

      # Control Center
      controlcenter = {
        BatteryShowPercentage = false;
        Bluetooth = false;
        Display = false;
        FocusModes = false;
        Sound = false;
      };

      # CustomUserPreferences settings not supported by nix-darwin directly, may be others? https://github.com/yannbertrand/macos-defaults (ryan)

      # Global UI/UX (NS = NeXTSTEP)
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        # _HIHideMenuBar = true; # For Sketchybar
        _HIHideMenuBar = false;
        "com.apple.keyboard.fnState" = false;
        # "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key
        # "com.apple.swipescrolldirection" = true; # enable natural scrolling(default to true)
      };
    };
  };
}
