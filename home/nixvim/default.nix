{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # imports = inputs.nvix.full;
    imports = with inputs.nvix.nvixPlugins; [
      ai
      common
      lang
      lsp
      lualine
      snacks
      autosession
      blink-cmp
      buffer
      firenvim
      git
      noice
      precognition
      smear-cursor
      tex
      treesitter
      ux
    ];
  };
}
