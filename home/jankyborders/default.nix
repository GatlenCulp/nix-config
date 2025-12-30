# A lightweight window border system for macOS
{
  services.jankyborders = {
    enable = true;
    settings = {
      # Settings are extremely basic: https://github.com/FelixKratz/JankyBorders/wiki/Man-Page
      style = "round";
      width = 5.0;
      hidpi = "off";
      active_color = "0xffe2e2e3";
      inactive_color = "0xff414550";
    };
  };
}
