{
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
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "clmv";
      QuitMenuItem = true;
      ShowPathbar = true;
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

    # Global UI/UX
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      "com.apple.keyboard.fnState" = false;
    };
  };
}
