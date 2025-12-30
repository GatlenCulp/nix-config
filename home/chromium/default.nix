# Doesn't work on darwin boooo
# Can customize extension keyboard shortcuts in chrome at chrome://extensions/shortcuts
# But otherwise you need to set app shortcuts using the menubar name
# TODO: For the sake of accidents, stop swipe actions `defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool TRUE`
{
  programs.chromium = {
    enable = true;
  };
}
