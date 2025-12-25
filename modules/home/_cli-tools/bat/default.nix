{
  bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "ov -F -H3";
    };
    # Run with --impure bc not changing this yet lol
    # themes.Dracula.src = "/Users/gat/.config/nix-darwin/assets/Dracula.tmTheme";
    # themes.dracula = {
    #   # TODO: learn about this more generally. ALso just does not work oops.
    #   src = pkgs.fetchFromGitHub {
    #     owner = "dracula";
    #     repo = "sublime";
    #     rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
    #     sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
    #   };
    #   file = "Dracula.tmTheme";
    # };
  };
}
