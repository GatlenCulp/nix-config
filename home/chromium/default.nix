# Doesn't work on darwin boooo
# Can customize extension keyboard shortcuts in chrome at chrome://extensions/shortcuts
# But otherwise you need to set app shortcuts using the menubar name
{
  programs.chromium = {
    enable = true;
  };
}
