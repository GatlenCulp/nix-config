{ ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles."GatlenCulp@gmail.com" = {
      isDefault = true;
    };
    # Go to settings then about:config
    settings = {
      mailnews.message_display.disable_remote_image = false; # Borderline unusable without remote images unfortunately
      # mail.threadpane.listview = 1; # I think table view instead of list view messages(?)
    };
    # extensions = [  ]; Basically not workable lol
    # Cardbook is better than their regular contacts
    # Auto Profile Picture is also a must-have extension.
    # Thunderbird is kind of ass as a client
  };
}
