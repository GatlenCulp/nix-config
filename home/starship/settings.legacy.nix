# Legacy Nix source — preserved for reference / switch-back. NOT imported.
{
  format = "[╭](fg:current_line)$os$directory$git_branch$git_status$fill$nodejs$bun$deno$aws$cmd_duration$shell$time$username$line_break$character";

  palette = "dracula";
  add_newline = true;

  # TODO:
  # https://starship.rs/config/#mise
  # https://starship.rs/config/#typst
  # https://starship.rs/config/#nix-shell
  # https://starship.rs/config/#python
  # https://starship.rs/config/#container
  #  Better git generally
  # https://starship.rs/config/#character

  palettes = {
    dracula = {
      foreground = "#F8F8F2";
      background = "#282A36";
      current_line = "#44475A";
      primary = "#1E1F29";
      box = "#44475A";
      blue = "#6272A4";
      cyan = "#8BE9FD";
      green = "#50FA7B";
      orange = "#FFB86C";
      pink = "#FF79C6";
      purple = "#BD93F9";
      red = "#FF5555";
      yellow = "#F1FA8C";
    };
  };

  os = {
    format = "(fg:current_line)[](fg:red)[$symbol ](fg:primary bg:red)[](fg:red)";
    disabled = false;
    symbols = {
      Alpine = "";
      Amazon = "";
      Android = "";
      Arch = "";
      CentOS = "";
      Debian = "";
      EndeavourOS = "";
      Fedora = "";
      FreeBSD = "";
      Garuda = "";
      Gentoo = "";
      Linux = "";
      Macos = "";
      Manjaro = "";
      Mariner = "";
      Mint = "";
      NetBSD = "";
      NixOS = "";
      OpenBSD = "";
      OpenCloudOS = "";
      openEuler = "";
      openSUSE = "";
      OracleLinux = "⊂⊃";
      Pop = "";
      Raspbian = "";
      Redhat = "";
      RedHatEnterprise = "";
      Solus = "";
      SUSE = "";
      Ubuntu = "";
      Unknown = "";
      Windows = "";
    };
  };

  directory = {
    format = "[─](fg:current_line)[](fg:pink)[󰷏 ](fg:primary bg:pink)[](fg:pink bg:box)[ $read_only$truncation_symbol$path](fg:foreground bg:box)[](fg:box)";
    home_symbol = " ~/";
    truncation_symbol = " ";
    truncation_length = 2;
    read_only = "󱧵 ";
    read_only_style = "";
  };

  git_branch = {
    format = "[─](fg:current_line)[](fg:green)[$symbol](fg:primary bg:green)[](fg:green bg:box)[ $branch](fg:foreground bg:box)";
    symbol = " ";
  };

  git_status = {
    format = "[( $all_status)](fg:foreground bg:box)[](fg:box)";
  };

  nodejs = {
    format = "[─](fg:current_line)[](fg:green)[$symbol](fg:primary bg:green)[](fg:green bg:box)[ $version](fg:foreground bg:box)[](fg:box)";
    detect_files = [
      "package.json"
      ".node-version"
      "!bunfig.toml"
      "!bun.lockb"
    ];
  };

  bun = {
    format = "[─](fg:current_line)[](fg:green)[$symbol](fg:primary bg:green)[](fg:green bg:box)[ $version](fg:foreground bg:box)[](fg:box)";
    symbol = "🥟";
  };

  deno = {
    format = "[─](fg:current_line)[](fg:green)[$symbol](fg:primary bg:green)[](fg:green bg:box)[ $version](fg:foreground bg:box)[](fg:box)";
    symbol = "🦕";
  };

  aws = {
    format = "[─](fg:current_line)[](fg:purple)[$symbol](fg:primary bg:purple)[](fg:purple bg:box)[ $profile](fg:foreground bg:box)[](fg:box)";
    symbol = "☁️";
  };

  fill = {
    symbol = "─";
    style = "fg:current_line";
  };

  cmd_duration = {
    min_time = 500;
    format = "[─](fg:current_line)[](fg:orange)[ ](fg:primary bg:orange)[](fg:orange bg:box)[ $duration ](fg:foreground bg:box)[](fg:box)";
  };

  shell = {
    format = "[─](fg:current_line)[](fg:blue)[ ](fg:primary bg:blue)[](fg:blue bg:box)[ $indicator](fg:foreground bg:box)[](fg:box)";
    disabled = false;
  };

  time = {
    format = "[─](fg:current_line)[](fg:purple)[󰦖 ](fg:primary bg:purple)[](fg:purple bg:box)[ $time](fg:foreground bg:box)[](fg:box)";
    time_format = "%H:%M";
    disabled = false;
  };

  username = {
    format = "[─](fg:current_line)[](fg:yellow)[ ](fg:primary bg:yellow)[](fg:yellow bg:box)[ $user](fg:foreground bg:box)[](fg:box) ";
    show_always = true;
  };

  character = {
    format = ''
      [│](fg:current_line)
      [╰─$symbol](fg:current_line) '';
    success_symbol = "[](fg:bold green)";
    error_symbol = "[](fg:bold red)";
    vimcmd_symbol = "[](fg:bold green)";
    vimcmd_replace_one_symbol = "[](fg:bold purple)";
    vimcmd_replace_symbol = "[](fg:bold purple)";
    vimcmd_visual_symbol = "[](fg:bold yellow)";
  };
}
