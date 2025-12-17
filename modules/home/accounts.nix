let
  googleAccountDefaults = {
    imap = {
      host = "imap.gmail.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "smtp.gmail.com";
      port = 465;
      tls.enable = true;
    };
    signature = {
      text = ''
        Best,
        Gatlen Culp
      '';
      showSignature = "append";
    };
    thunderbird.enable = true;
    mbsync.enable = true;
    mbsync.create = "maildir";
    msmtp.enable = true;
    notmuch.enable = true;
  };
in
{
  email.accounts = {
    "GatlenCulp@gmail.com" = googleAccountDefaults // {
      primary = true;
      realName = "Gatlen Culp";
      address = "GatlenCulp@gmail.com";
      userName = "GatlenCulp@gmail.com";
      passwordCommand = "lpass show 5114264351238405522 --password";
    };

    "culpdesigns2@gmail.com" = googleAccountDefaults // {
      realName = "Gatlen Culp";
      address = "culpdesigns2@gmail.com";
      userName = "culpdesigns2@gmail.com";
      passwordCommand = "lpass show 5216794005647503185 --password";
    };
  };
  # TODO: Complete in the future
  calendar.accounts = {
    "test-calendar" = {
      primary = true;
      remote.type = "google_calendar";
      remote.userName = "test-username";
      remote.passwordCommand = "lpass show 5216794005647503185 --password";
      # thunderbird.enable = true;
    };
  };
}
