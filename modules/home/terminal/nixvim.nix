{ pkgs, inputs }:
{
  # Use `nixvim-print-init` to see what this renders to
  enable = true;
  viAlias = true;
  vimAlias = true;

  # Import nvix modules for a solid foundation
  # imports = [
  #   inputs.nvix.nvixPlugins.common
  #   inputs.nvix.nvixPlugins.lualine
  #   # inputs.nvix.nvixPlugins.snacks
  #   # inputs.nvix.nvixPlugins.which-key
  #   # inputs.nvix.nvixPlugins.treesitter
  #   # inputs.nvix.nvixPlugins.lsp
  #   # inputs.nvix.nvixPlugins.cmp
  #   # inputs.nvix.nvixPlugins.git
  # ];

  # ============================================================================
  # OPTIONS (Override nvix defaults where needed)
  # ============================================================================
  # opts = {
  #   # Line numbers
  #   number = true;
  #   relativenumber = true;
  #   cursorline = true;

  #   # Indentation
  #   expandtab = true;
  #   shiftwidth = 4;
  #   # smartindent = true; # Handled by tree sitter
  #   softtabstop = 4;
  #   tabstop = 4;

  #   # Search
  #   ignorecase = true;
  #   smartcase = true;

  #   # Display
  #   termguicolors = true;
  #   background = "dark";
  #   showmatch = true;
  #   signcolumn = "yes";
  #   showmode = false;

  #   # Performance
  #   updatetime = 300;
  #   timeoutlen = 500;

  #   # Files
  #   swapfile = false;
  #   undofile = true;
  #   undodir.__raw = "vim.fn.expand('~/.vim/undodir')";
  # };

  # dependencies = {
  #   bat.enable = true;
  #   # claude-code.enable = true;
  #   gh.enable = true;
  #   git.enable = true;
  #   tinymist.enable = true;
  #   typst.enable = true;
  #   tree-sitter.enable = true;
  # };

  # globals.mapleader = "\\";

  # # ============================================================================
  # # COLORSCHEME (Override nvix default)
  # # ============================================================================
  # colorschemes.dracula.enable = true;

  # # ============================================================================
  # # HIGHLIGHTS
  # # ============================================================================
  # highlightOverride = {
  #   WhichKeyIcon = { link = "Function"; };  # Remove underline from which-key icons
  # };

  # # ============================================================================
  # # KEYMAPS
  # # ============================================================================
  # keymaps = [
  #   # -- Window Navigation --
  #   { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options = { noremap = true; silent = true; desc = "Go to Left Window"; }; }
  #   { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options = { noremap = true; silent = true; desc = "Go to Lower Window"; }; }
  #   { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options = { noremap = true; silent = true; desc = "Go to Upper Window"; }; }
  #   { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options = { noremap = true; silent = true; desc = "Go to Right Window"; }; }

  #   # -- File Operations --
  #   { mode = "n"; key = "<leader>w"; action = ":w<CR>"; options = { noremap = true; silent = true; desc = "Save File"; }; }

  #   # -- Search --
  #   { mode = "n"; key = "<leader>h"; action = ":noh<CR>"; options = { noremap = true; silent = true; desc = "Clear Search Highlight"; }; }

  #   # -- Buffer Navigation --
  #   { mode = "n"; key = "<leader>bn"; action = ":bnext<CR>"; options = { noremap = true; silent = true; desc = "Next Buffer"; }; }
  #   { mode = "n"; key = "<leader>bp"; action = ":bprevious<CR>"; options = { noremap = true; silent = true; desc = "Previous Buffer"; }; }

  #   # -- AI --
  #   { mode = "n"; key = "<leader>cc"; action = "<cmd>ClaudeCode<CR>"; options.desc = "Toggle Claude Code"; }

  #   # -- Which-Key Help --
  #   { mode = "n"; key = "<leader>?"; action.__raw = "function() require('which-key').show({ global = false }) end"; options.desc = "Buffer Local Keymaps"; }

  #   # ==========================================================================
  #   # SNACKS
  #   # ==========================================================================

  #   # -- Top Pickers & Explorer --
  #   { mode = "n"; key = "<leader><space>"; action.__raw = "function() Snacks.picker.smart() end"; options.desc = "Smart Find Files"; }
  #   { mode = "n"; key = "<leader>,"; action.__raw = "function() Snacks.picker.buffers() end"; options.desc = "Switch Buffer"; }
  #   { mode = "n"; key = "<leader>/"; action.__raw = "function() Snacks.picker.grep() end"; options.desc = "Grep in Project"; }
  #   { mode = "n"; key = "<leader>:"; action.__raw = "function() Snacks.picker.command_history() end"; options.desc = "Command History"; }
  #   { mode = "n"; key = "<leader>e"; action.__raw = "function() Snacks.explorer() end"; options.desc = "File Explorer"; }

  #   # -- Find --
  #   { mode = "n"; key = "<leader>fb"; action.__raw = "function() Snacks.picker.buffers() end"; options.desc = "Buffers"; }
  #   { mode = "n"; key = "<leader>fC"; action.__raw = "function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end"; options.desc = "Config Files"; }
  #   { mode = "n"; key = "<leader>ff"; action.__raw = "function() Snacks.picker.files() end"; options.desc = "Files"; }
  #   { mode = "n"; key = "<leader>fg"; action.__raw = "function() Snacks.picker.git_files() end"; options.desc = "Git Files"; }
  #   { mode = "n"; key = "<leader>fh"; action.__raw = "function() Snacks.picker.help() end"; options.desc = "Help Pages"; }
  #   { mode = "n"; key = "<leader>fk"; action.__raw = "function() Snacks.picker.keymaps() end"; options.desc = "Keymaps"; }
  #   { mode = "n"; key = "<leader>fp"; action.__raw = "function() Snacks.picker.projects() end"; options.desc = "Projects"; }
  #   { mode = "n"; key = "<leader>fr"; action.__raw = "function() Snacks.picker.recent() end"; options.desc = "Recent Files"; }

  #   # -- Git --
  #   { mode = "n"; key = "<leader>gb"; action.__raw = "function() Snacks.picker.git_branches() end"; options.desc = "Branches"; }
  #   { mode = "n"; key = "<leader>gl"; action.__raw = "function() Snacks.picker.git_log() end"; options.desc = "Log"; }
  #   { mode = "n"; key = "<leader>gL"; action.__raw = "function() Snacks.picker.git_log_line() end"; options.desc = "Log (Current Line)"; }
  #   { mode = "n"; key = "<leader>gs"; action.__raw = "function() Snacks.picker.git_status() end"; options.desc = "Status"; }
  #   { mode = "n"; key = "<leader>gS"; action.__raw = "function() Snacks.picker.git_stash() end"; options.desc = "Stash"; }
  #   { mode = "n"; key = "<leader>gd"; action.__raw = "function() Snacks.picker.git_diff() end"; options.desc = "Diff Hunks"; }
  #   { mode = "n"; key = "<leader>gf"; action.__raw = "function() Snacks.picker.git_log_file() end"; options.desc = "Log (Current File)"; }
  #   { mode = "n"; key = "<leader>gB"; action.__raw = "function() Snacks.gitbrowse() end"; options.desc = "Browse in Browser"; }
  #   { mode = "v"; key = "<leader>gB"; action.__raw = "function() Snacks.gitbrowse() end"; options.desc = "Browse in Browser"; }
  #   { mode = "n"; key = "<leader>gg"; action.__raw = "function() Snacks.lazygit() end"; options.desc = "Lazygit"; }

  #   # -- GitHub --
  #   { mode = "n"; key = "<leader>Gi"; action.__raw = "function() Snacks.picker.gh_issue() end"; options.desc = "Issues (Open)"; }
  #   { mode = "n"; key = "<leader>GI"; action.__raw = "function() Snacks.picker.gh_issue({ state = 'all' }) end"; options.desc = "Issues (All)"; }
  #   { mode = "n"; key = "<leader>Gp"; action.__raw = "function() Snacks.picker.gh_pr() end"; options.desc = "Pull Requests (Open)"; }
  #   { mode = "n"; key = "<leader>GP"; action.__raw = "function() Snacks.picker.gh_pr({ state = 'all' }) end"; options.desc = "Pull Requests (All)"; }

  #   # -- Grep --
  #   { mode = "n"; key = "<leader>sb"; action.__raw = "function() Snacks.picker.lines() end"; options.desc = "Buffer Lines"; }
  #   { mode = "n"; key = "<leader>sB"; action.__raw = "function() Snacks.picker.grep_buffers() end"; options.desc = "Grep Open Buffers"; }
  #   { mode = "n"; key = "<leader>sg"; action.__raw = "function() Snacks.picker.grep() end"; options.desc = "Grep Project"; }
  #   { mode = "n"; key = "<leader>sw"; action.__raw = "function() Snacks.picker.grep_word() end"; options.desc = "Word Under Cursor"; }
  #   { mode = "x"; key = "<leader>sw"; action.__raw = "function() Snacks.picker.grep_word() end"; options.desc = "Selection"; }

  #   # -- Search --
  #   { mode = "n"; key = "<leader>s\""; action.__raw = "function() Snacks.picker.registers() end"; options.desc = "Registers"; }
  #   { mode = "n"; key = "<leader>s/"; action.__raw = "function() Snacks.picker.search_history() end"; options.desc = "Search History"; }
  #   { mode = "n"; key = "<leader>sa"; action.__raw = "function() Snacks.picker.autocmds() end"; options.desc = "Autocommands"; }
  #   { mode = "n"; key = "<leader>sc"; action.__raw = "function() Snacks.picker.command_history() end"; options.desc = "Command History"; }
  #   { mode = "n"; key = "<leader>sC"; action.__raw = "function() Snacks.picker.commands() end"; options.desc = "Commands"; }
  #   { mode = "n"; key = "<leader>sd"; action.__raw = "function() Snacks.picker.diagnostics() end"; options.desc = "Workspace Diagnostics"; }
  #   { mode = "n"; key = "<leader>sD"; action.__raw = "function() Snacks.picker.diagnostics_buffer() end"; options.desc = "Buffer Diagnostics"; }
  #   { mode = "n"; key = "<leader>sh"; action.__raw = "function() Snacks.picker.help() end"; options.desc = "Help Pages"; }
  #   { mode = "n"; key = "<leader>sH"; action.__raw = "function() Snacks.picker.highlights() end"; options.desc = "Highlight Groups"; }
  #   { mode = "n"; key = "<leader>si"; action.__raw = "function() Snacks.picker.icons() end"; options.desc = "Icons"; }
  #   { mode = "n"; key = "<leader>sj"; action.__raw = "function() Snacks.picker.jumps() end"; options.desc = "Jump List"; }
  #   { mode = "n"; key = "<leader>sk"; action.__raw = "function() Snacks.picker.keymaps() end"; options.desc = "Keymaps"; }
  #   { mode = "n"; key = "<leader>sl"; action.__raw = "function() Snacks.picker.loclist() end"; options.desc = "Location List"; }
  #   { mode = "n"; key = "<leader>sm"; action.__raw = "function() Snacks.picker.marks() end"; options.desc = "Marks"; }
  #   { mode = "n"; key = "<leader>sM"; action.__raw = "function() Snacks.picker.man() end"; options.desc = "Man Pages"; }
  #   { mode = "n"; key = "<leader>sp"; action.__raw = "function() Snacks.picker.lazy() end"; options.desc = "Plugin Specs"; }
  #   { mode = "n"; key = "<leader>sq"; action.__raw = "function() Snacks.picker.qflist() end"; options.desc = "Quickfix List"; }
  #   { mode = "n"; key = "<leader>sR"; action.__raw = "function() Snacks.picker.resume() end"; options.desc = "Resume Last Picker"; }
  #   { mode = "n"; key = "<leader>su"; action.__raw = "function() Snacks.picker.undo() end"; options.desc = "Undo Tree"; }

  #   # -- LSP --
  #   { mode = "n"; key = "gd"; action.__raw = "function() Snacks.picker.lsp_definitions() end"; options.desc = "Definition"; }
  #   { mode = "n"; key = "gD"; action.__raw = "function() Snacks.picker.lsp_declarations() end"; options.desc = "Declaration"; }
  #   { mode = "n"; key = "gr"; action.__raw = "function() Snacks.picker.lsp_references() end"; options = { nowait = true; desc = "References"; }; }
  #   { mode = "n"; key = "gI"; action.__raw = "function() Snacks.picker.lsp_implementations() end"; options.desc = "Implementation"; }
  #   { mode = "n"; key = "gy"; action.__raw = "function() Snacks.picker.lsp_type_definitions() end"; options.desc = "Type Definition"; }
  #   { mode = "n"; key = "gai"; action.__raw = "function() Snacks.picker.lsp_incoming_calls() end"; options.desc = "Incoming Calls"; }
  #   { mode = "n"; key = "gao"; action.__raw = "function() Snacks.picker.lsp_outgoing_calls() end"; options.desc = "Outgoing Calls"; }
  #   { mode = "n"; key = "<leader>ss"; action.__raw = "function() Snacks.picker.lsp_symbols() end"; options.desc = "Document Symbols"; }
  #   { mode = "n"; key = "<leader>sS"; action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end"; options.desc = "Workspace Symbols"; }

  #   # -- Other --
  #   { mode = "n"; key = "<leader>z"; action.__raw = "function() Snacks.zen() end"; options.desc = "Toggle Zen Mode"; }
  #   { mode = "n"; key = "<leader>Z"; action.__raw = "function() Snacks.zen.zoom() end"; options.desc = "Toggle Zoom"; }
  #   { mode = "n"; key = "<leader>."; action.__raw = "function() Snacks.scratch() end"; options.desc = "Toggle Scratch Buffer"; }
  #   { mode = "n"; key = "<leader>S"; action.__raw = "function() Snacks.scratch.select() end"; options.desc = "Select Scratch Buffer"; }
  #   { mode = "n"; key = "<leader>n"; action.__raw = "function() Snacks.notifier.show_history() end"; options.desc = "Notification History"; }
  #   { mode = "n"; key = "<leader>bd"; action.__raw = "function() Snacks.bufdelete() end"; options.desc = "Delete Buffer"; }
  #   { mode = "n"; key = "<leader>cR"; action.__raw = "function() Snacks.rename.rename_file() end"; options.desc = "Rename File"; }
  #   { mode = "n"; key = "<leader>un"; action.__raw = "function() Snacks.notifier.hide() end"; options.desc = "Dismiss All Notifications"; }
  #   { mode = "n"; key = "<leader>uC"; action.__raw = "function() Snacks.picker.colorschemes() end"; options.desc = "Pick Colorscheme"; }
  #   { mode = "n"; key = "<c-/>"; action.__raw = "function() Snacks.terminal() end"; options.desc = "Toggle Terminal"; }
  #   { mode = "n"; key = "<c-_>"; action.__raw = "function() Snacks.terminal() end"; options.desc = "Toggle Terminal"; }
  #   { mode = "n"; key = "]]"; action.__raw = "function() Snacks.words.jump(vim.v.count1) end"; options.desc = "Next Word Reference"; }
  #   { mode = "t"; key = "]]"; action.__raw = "function() Snacks.words.jump(vim.v.count1) end"; options.desc = "Next Word Reference"; }
  #   { mode = "n"; key = "[["; action.__raw = "function() Snacks.words.jump(-vim.v.count1) end"; options.desc = "Previous Word Reference"; }
  #   { mode = "t"; key = "[["; action.__raw = "function() Snacks.words.jump(-vim.v.count1) end"; options.desc = "Previous Word Reference"; }
  # ];

  # # ============================================================================
  # # PLUGINS
  # # ============================================================================
  # plugins = {

  #   # ==========================================================================
  #   # CORE
  #   # ==========================================================================

  #   # -- Syntax & Parsing --
  #   treesitter = {
  #     enable = true;
  #     grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  #     settings = {
  #       highlight.enable = true;
  #       indent.enable = true;
  #     };
  #   };
  #   # treesitter-context.enable = true; # Sticky header showing current function/class (slightly annoying rn)

  #   # -- Fuzzy Finder --
  #   # telescope.enable = true; # Replaced by snacks picker

  #   # -- Session Management --
  #   auto-session.enable = true;

  #   # ==========================================================================
  #   # UI / UX
  #   # ==========================================================================

  #   # -- Status & Info --
  #   lualine = {
  #     enable = true;
  #     settings.options = {
  #       theme = "dracula";
  #       component_separators = {
  #         left = "|";
  #         right = "|";
  #       };
  #       section_separators = {
  #         left = "";
  #         right = "";
  #       };
  #     };
  #   };
  #   # barbar.enable = true; # Buffer tabs # Will introduce later.
  #   # dropbar.enable = true; # Breadcrumbs # Will introduce later.
  #   # fidget.enable = true; # LSP progress notifications (Slightly annoying rn) # Will introduce later.
  #   # noice.enable = true; # Command UI in center, uses nvim-notify under the hood, also snacks has its own notification mechanism
  #   which-key = {
  #     enable = true;
  #     settings = {
  #       preset = "modern";
  #       plugins.spelling.enabled = true;
  #       sort = [ "local" "order" "alphanum" "mod" ]; # removed "group" so groups aren't pushed to the end
  #       spec = [
  #         # ====================================================================
  #         # GROUPS
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader>b"; group = "Buffer"; icon = { icon = "󰈔"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>c"; group = "Code"; icon = { icon = "󰅩"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>f"; group = "Find"; icon = { icon = "󰈞"; color = "green"; }; }
  #         { __unkeyed-1 = "<leader>g"; group = "Git"; icon = { icon = "󰊢"; color = "orange"; }; }
  #         { __unkeyed-1 = "<leader>G"; group = "GitHub"; icon = { icon = "󰊤"; color = "purple"; }; }
  #         { __unkeyed-1 = "<leader>s"; group = "Search"; icon = { icon = "󰍉"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>u"; group = "UI"; icon = { icon = "󰙵"; color = "cyan"; }; }
  #         { __unkeyed-1 = "g"; group = "Goto"; icon = { icon = "󰁕"; color = "blue"; }; }
  #         { __unkeyed-1 = "ga"; group = "Calls"; icon = { icon = "󰏻"; color = "purple"; }; }

  #         # ====================================================================
  #         # TOP-LEVEL LEADER KEYS
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader><space>"; icon = { icon = "󰈞"; color = "green"; }; }
  #         { __unkeyed-1 = "<leader>,"; icon = { icon = "󰈔"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>/"; icon = { icon = "󰈬"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>:"; icon = { icon = "󰘳"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>e"; icon = { icon = "󰙅"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>w"; icon = { icon = "󰆓"; color = "green"; }; }
  #         { __unkeyed-1 = "<leader>h"; icon = { icon = "󰸱"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>?"; icon = { icon = "󰋖"; color = "purple"; }; }
  #         { __unkeyed-1 = "<leader>z"; icon = { icon = "󰰶"; color = "azure"; }; }
  #         { __unkeyed-1 = "<leader>Z"; icon = { icon = "󰁌"; color = "azure"; }; }
  #         { __unkeyed-1 = "<leader>."; icon = { icon = "󰏫"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>S"; icon = { icon = "󰏫"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>n"; icon = { icon = "󰂞"; color = "yellow"; }; }

  #         # ====================================================================
  #         # BUFFER (<leader>b)
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader>bn"; icon = { icon = "󰒭"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>bp"; icon = { icon = "󰒮"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>bd"; icon = { icon = "󰅖"; color = "red"; }; }

  #         # ====================================================================
  #         # CODE (<leader>c)
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader>cc"; icon = { icon = "󰚩"; color = "purple"; }; }
  #         { __unkeyed-1 = "<leader>cR"; icon = { icon = "󰑕"; color = "cyan"; }; }

  #         # ====================================================================
  #         # FIND (<leader>f)
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader>fb"; icon = { icon = "󰈔"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>fC"; icon = { icon = "󰒓"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>ff"; icon = { icon = "󰈞"; color = "green"; }; }
  #         { __unkeyed-1 = "<leader>fg"; icon = { icon = "󰊢"; color = "orange"; }; }
  #         { __unkeyed-1 = "<leader>fh"; icon = { icon = "󰋖"; color = "purple"; }; }
  #         { __unkeyed-1 = "<leader>fk"; icon = { icon = "󰌌"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>fp"; icon = { icon = "󰉋"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>fr"; icon = { icon = "󰋚"; color = "yellow"; }; }

  #         # ====================================================================
  #         # GIT (<leader>g)
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader>gb"; icon = { icon = "󰘬"; color = "orange"; }; }
  #         { __unkeyed-1 = "<leader>gl"; icon = { icon = "󰋚"; color = "orange"; }; }
  #         { __unkeyed-1 = "<leader>gL"; icon = { icon = "󰦨"; color = "orange"; }; }
  #         { __unkeyed-1 = "<leader>gs"; icon = { icon = "󱖫"; color = "green"; }; }
  #         { __unkeyed-1 = "<leader>gS"; icon = { icon = "󰆓"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>gd"; icon = { icon = "󰦓"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>gf"; icon = { icon = "󰈙"; color = "orange"; }; }
  #         { __unkeyed-1 = "<leader>gB"; icon = { icon = "󰖟"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>gg"; icon = { icon = "󰊢"; color = "orange"; }; }

  #         # ====================================================================
  #         # GITHUB (<leader>G)
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader>Gi"; icon = { icon = "󰌪"; color = "green"; }; }
  #         { __unkeyed-1 = "<leader>GI"; icon = { icon = "󰌪"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>Gp"; icon = { icon = "󰘬"; color = "purple"; }; }
  #         { __unkeyed-1 = "<leader>GP"; icon = { icon = "󰘬"; color = "grey"; }; }

  #         # ====================================================================
  #         # SEARCH (<leader>s)
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader>sb"; icon = { icon = "󰍉"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>sB"; icon = { icon = "󰈬"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>sg"; icon = { icon = "󰈬"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>sw"; icon = { icon = "󰗧"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>s\""; icon = { icon = "󱓥"; color = "purple"; }; }
  #         { __unkeyed-1 = "<leader>s/"; icon = { icon = "󰋚"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>sa"; icon = { icon = "󰒓"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>sc"; icon = { icon = "󰘳"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>sC"; icon = { icon = "󰘳"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>sd"; icon = { icon = "󰒡"; color = "red"; }; }
  #         { __unkeyed-1 = "<leader>sD"; icon = { icon = "󰒡"; color = "orange"; }; }
  #         { __unkeyed-1 = "<leader>sh"; icon = { icon = "󰋖"; color = "purple"; }; }
  #         { __unkeyed-1 = "<leader>sH"; icon = { icon = "󰌁"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>si"; icon = { icon = "󰭟"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>sj"; icon = { icon = "󱋿"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>sk"; icon = { icon = "󰌌"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>sl"; icon = { icon = "󰍒"; color = "blue"; }; }
  #         { __unkeyed-1 = "<leader>sm"; icon = { icon = "󰃀"; color = "red"; }; }
  #         { __unkeyed-1 = "<leader>sM"; icon = { icon = "󰗚"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>sp"; icon = { icon = "󰏗"; color = "purple"; }; }
  #         { __unkeyed-1 = "<leader>sq"; icon = { icon = "󰁨"; color = "orange"; }; }
  #         { __unkeyed-1 = "<leader>sR"; icon = { icon = "󰑓"; color = "green"; }; }
  #         { __unkeyed-1 = "<leader>su"; icon = { icon = "󰕌"; color = "yellow"; }; }
  #         { __unkeyed-1 = "<leader>ss"; icon = { icon = "󰊕"; color = "cyan"; }; }
  #         { __unkeyed-1 = "<leader>sS"; icon = { icon = "󰊕"; color = "blue"; }; }

  #         # ====================================================================
  #         # UI (<leader>u)
  #         # ====================================================================
  #         { __unkeyed-1 = "<leader>un"; icon = { icon = "󰂛"; color = "grey"; }; }
  #         { __unkeyed-1 = "<leader>uC"; icon = { icon = "󰏘"; color = "purple"; }; }

  #         # ====================================================================
  #         # GOTO (g)
  #         # ====================================================================
  #         { __unkeyed-1 = "gd"; icon = { icon = "󰈮"; color = "blue"; }; }
  #         { __unkeyed-1 = "gD"; icon = { icon = "󰈮"; color = "cyan"; }; }
  #         { __unkeyed-1 = "gr"; icon = { icon = "󰌹"; color = "yellow"; }; }
  #         { __unkeyed-1 = "gI"; icon = { icon = "󰘧"; color = "green"; }; }
  #         { __unkeyed-1 = "gy"; icon = { icon = "󰊄"; color = "purple"; }; }
  #         { __unkeyed-1 = "gai"; icon = { icon = "󰏷"; color = "cyan"; }; }
  #         { __unkeyed-1 = "gao"; icon = { icon = "󰏻"; color = "orange"; }; }

  #         # ====================================================================
  #         # NAVIGATION
  #         # ====================================================================
  #         { __unkeyed-1 = "]]"; icon = { icon = "󰒭"; color = "blue"; }; }
  #         { __unkeyed-1 = "[["; icon = { icon = "󰒮"; color = "blue"; }; }
  #       ];
  #     };
  #   };
  #   snacks = {
  #     enable = true;
  #     settings = {
  #       bigfile.enabled = true; # Disables some things from spinning up on massive files
  #       notifier.enabled = true; # Better notifications system
  #       quickfile.enabled = true; # Loads file before plugins
  #       statuscolumn.enabled = true;
  #       # dashboard.enabled = true; # Not working
  #       # scroll.enabled = true; # Not working?
  #     };
  #   };

  #   # -- Visual Enhancements --
  #   colorizer.enable = true; # Highlight color codes (#fff, rgb, etc.)
  #   illuminate.enable = true; # Highlight other instances of symbol under cursor
  #   rainbow.enable = true; # Rainbow delimiters
  #   neoscroll.enable = true; # Smooth scrolling (not using snacks scroll, perhaps switch.)
  #   transparent.enable = true; # Transparent background
  #   web-devicons.enable = true; # File icons

  #   # -- Navigation Helpers --
  #   leap.enable = true; # Label-based navigation (like sneak, improved)
  #   hardtime = {
  #     enable = true;
  #           disabled_keys = {};
  #           format_on_save = true;
  #     settings = {
  #       restriction_mode = "hint";
  #       disable_mouse = false;
  #     }; # Only hint, don't block
  #   }; # Hints when repeatedly pressing keys
  #   precognition.enable = true; # Shows available motions

  #   # ==========================================================================
  #   # FILE MANAGEMENT
  #   # ==========================================================================
  #   # neo-tree.enable = true; # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html

  #   # ==========================================================================
  #   # GIT
  #   # ==========================================================================
  #   gitsigns = {
  #     enable = true;
  #     settings.signs = {
  #       add.text = "+";
  #       change.text = "~";
  #       delete.text = "_";
  #       topdelete.text = "‾";
  #       changedelete.text = "~";
  #     };
  #   };
  #   diffview.enable = true; # Git diff viewer

  #   # ==========================================================================
  #   # AI / ASSISTANTS
  #   # ==========================================================================
  #   avante.enable = true; # AI assistant integration

  #   # ==========================================================================
  #   # EDITING
  #   # ==========================================================================

  #   # -- Auto-pairs & Completion --
  #   nvim-autopairs = {
  #     enable = true;
  #     settings = {
  #       check_ts = true;
  #       ts_config = {
  #         lua = [ "string" ];
  #         javascript = [ "template_string" ];
  #       };
  #     };
  #   };
  #   # blink-cmp.enable = true; # Rust-based completion engine
  #   coq.enable = true; # Just want something out of box

  #   # -- Comments --
  #   comment = {
  #     enable = true;
  #     settings.ignore = "^$"; # Don't comment empty lines
  #   };
  #   todo-comments.enable = false; # Highlight TODO, FIXME, etc. (Poorly formatted atm, fix later)

  #   # -- Code Manipulation --
  #   nvim-ufo.enable = false; # Code folding
  #   refactoring.enable = true; # Refactoring utilities
  #   nvim-lightbulb.enable = true; # Code action indicator

  #   # ==========================================================================
  #   # LSP & DIAGNOSTICS
  #   # ==========================================================================
  #   lsp = {
  #     enable = true;
  #   inlayHints = true;
  #     servers = {
  #       ts_ls.enable = true; # TS/JS
  #       cssls.enable = true; # CSS
  #       tailwindcss.enable = true; # TailwindCSS
  #       html.enable = true; # HTML
  #       svelte.enable = false; # Svelte
  #       pyright.enable = true; # Python
  #       marksman.enable = true; # Markdown
  #       nixd_ls.enable = true; # Nix
  #       dockerls.enable = true; # Docker
  #       bashls.enable = true; # Bash
  #       yamlls.enable = true; # YAML
  #       jsonls.enable = true; # JSON
  #       lua_ls.enable = true; # Lua
  #       # astro.enable = true; # AstroJS
  #       # phpactor.enable = true; # PHP
  #       # vuels.enable = false; # Vue
  #       # clangd.enable = true; # C/C++
  #       # csharp_ls.enable = true; # C# Not available
  #     };
  #   };
  #   trouble.enable = true; # Diagnostics panel
  #   # conform-nvim = {
  #   #     enable = true;
  #   #     autoInstall = {enable = true;};

  #   # };

  #   # ==========================================================================
  #   # DEBUGGING & TESTING
  #   # ==========================================================================
  #   dap.enable = true;
  #   dap-python.enable = true;
  #   dap-ui.enable = true;
  #   neotest = {
  #     enable = true;
  #     adapters.python.enable = true;
  #   };

  #   # ==========================================================================
  #   # LANGUAGES
  #   # ==========================================================================
  #   lean.enable = true; # LEAN theorem prover
  #   typst-preview.enable = true; # Typst live preview
  #   render-markdown.enable = true;
  #   schemastore = {enable = true; yaml.enable = true; json.enable = true;}; # JSON/YAML schema support
  #   csvview.enable = true; # CSV file viewer

  #   # ==========================================================================
  #   # REMOTE & INTEGRATION
  #   # ==========================================================================
  #   remote-nvim.enable = true; # Devcontainer and remote work
  #   iron.enable = true; # Interactive REPLs
  #   # kulala.enable = true; # REST client # Errors atm.
  #   toggleterm.enable = true; # Toggle terminal splits
  #   wakatime.enable = true; # Time tracking
  #   image.enable = true; # Render images
  #   img-clip.enable = true; # Drag-and-drop images for Typst, LaTeX

  #   # ==========================================================================
  #   # MISC
  #   # ==========================================================================
  #   # wilder.enable = true; # Enhanced wildmenu (apparenlty cmp-cmdline recommended?)
  #   vim-be-good.enable = true; # Vim practice games

  #   # ==========================================================================
  #   # CONSIDERING
  #   # Plugins to potentially enable in the future
  #   # ==========================================================================
  #   #
  #   # -- Startup Screens --
  #   # alpha.enable = true; # not working?                    # Startup screen (errors on empty config)
  #   # dashboard                               # https://nix-community.github.io/nixvim/plugins/dashboard/index.html
  #   # vim-startify                            # https://github.com/mhinz/vim-startify/
  #   #
  #   # -- UI Enhancements --
  #   # notify.enable = true;                   # Notifications (snacks-nvim has its own)
  #   smear-cursor.enable = true;             # Smear cursor effect (mini has this)
  #   # color-winsep                            # Colorizes window separators
  #   # scrollview                              # https://github.com/dstein64/nvim-scrollview/
  #   # twilight                                # https://github.com/folke/twilight.nvim/ - Dims inactive code
  #   #
  #   # -- Navigation --
  #   # flash                                   # https://github.com/folke/flash.nvim/ - Label-based search navigation
  #   # harpoon                                 # https://nix-community.github.io/nixvim/plugins/harpoon/index.html
  #   #
  #   # -- File Explorers --

  #   # nvim-tree                               # https://nix-community.github.io/nixvim/plugins/nvim-tree/index.html
  #   oil.enable = true;                                     # https://github.com/stevearc/oil.nvim - Edit filesystem like buffer
  #   # yazi                                    # https://github.com/mikavilpas/yazi.nvim/
  #   #
  #   # -- Git --
  #   # fugit2                                  # https://nix-community.github.io/nixvim/plugins/fugit2/index.html - Git GUI
  #   # fugitive                                # https://nix-community.github.io/nixvim/plugins/fugitive.html - Tim Pope's git wrapper
  #   # neogit                                  # https://github.com/NeogitOrg/neogit/
  #   # lazygit                                 # https://github.com/kdheepak/lazygit.nvim/ (snacks has this)
  #   #
  #   # -- AI --
  #   # opencode                                # https://nix-community.github.io/nixvim/plugins/opencode/index.html
  #   # sidekick                                # https://github.com/folke/sidekick.nvim/
  #   # supermaven                              # https://supermaven.com/
  #   #
  #   # -- Editing --
  #   # goto-preview                            # https://nix-community.github.io/nixvim/plugins/goto-preview/index.html
  #   # undotree                                # https://github.com/mbbill/undotree/
  #   # vim-surround                            # https://github.com/tpope/vim-surround/ (mini has this)
  #   # vim-sandwich                            # https://github.com/machakann/vim-sandwich/
  #   # vim-repeat                              # https://github.com/tpope/vim-repeat/
  #   # vim-sleuth                              # https://github.com/tpope/vim-sleuth/
  #   # yanky                                   # https://github.com/gbprod/yanky.nvim/
  #   # visual-multi                            # https://github.com/mg979/vim-visual-multi/ - Multi-cursor
  #   #
  #   # -- Mini.nvim Suite --
  #   # mini.enable = true;                     # Lots of small improvements:
  #   #   - Better around/inside textobjects
  #   #   - Surround (replaces vim-surround)
  #   #   - Animated cursor
  #   #   - Mini.files, mini.pick, etc.
  #   #
  #   # -- Code Quality --
  #   # conform-nvim                            # https://nix-community.github.io/nixvim/plugins/conform-nvim/index.html
  #   # lint                                    # https://nix-community.github.io/nixvim/plugins/lint/index.html
  #   # quicker                                 # https://nix-community.github.io/nixvim/plugins/quicker/index.html
  #   #
  #   # -- LSP Related --
  #   # helpview                                # https://github.com/OXY2DEV/helpview.nvim/
  #   hmts.enable = true;                                    # https://nix-community.github.io/nixvim/plugins/hmts/index.html - Treesitter for home-manager
  #   #
  #   # -- Testing --
  #   # vim-test                                # https://nix-community.github.io/nixvim/plugins/vim-test.html
  #   #
  #   # -- Languages --
  #   # vimtex                                  # https://github.com/lervag/vimtex/
  #   # molten-nvim                             # https://github.com/benlubas/molten-nvim/ - Jupyter in nvim
  #   #
  #   # -- Integration --
  #   # direnv                                  # https://nix-community.github.io/nixvim/plugins/direnv/index.html
  #   # distant                                 # https://github.com/chipsenkbeil/distant.nvim/ - Remote editing
  #   # firenvim                                # https://github.com/glacambre/firenvim/ - Nvim in browser
  #   # presence                                # https://github.com/andweeb/presence.nvim/ - Discord status
  #   #
  #   # -- Misc --
  #   # colorful-menu                           # https://github.com/xzbdmw/colorful-menu.nvim/
  #   # comment-box                             # https://github.com/LudoPinelli/comment-box.nvim/
  #   # lazy                                    # https://nix-community.github.io/nixvim/plugins/lazy/index.html
  #   # neoconf                                 # https://nix-community.github.io/nixvim/plugins/neoconf/index.html
  #   # neoclip                                 # https://github.com/AckslD/nvim-neoclip.lua/
  #   # nerdy                                   # https://nix-community.github.io/nixvim/plugins/nerdy/index.html - Nerd font search
  #   # smart-splits                            # https://nix-community.github.io/nixvim/plugins/smart-splits/index.html
  # };

  # # ============================================================================
  # # EXTRA CONFIG
  # # ============================================================================

  # # Lua config for plugins without nixvim modules
  # extraConfigLua = ''
  #   -- Claude Code (no nixvim module yet)
  #   local ok, claude = pcall(require, 'claude-code')
  #   if ok then claude.setup() end
  # '';

  # # Extra plugins not in nixvim
  # extraPlugins = with pkgs.vimPlugins; [
  #   # snacks-nvim
  #   claude-code-nvim
  # ];
}
