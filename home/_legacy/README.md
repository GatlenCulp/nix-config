# _legacy

Preserved home-manager modules that are no longer imported by any host, kept
for reference and easy rollback. `nvim-nixvim/` is the old nixvim/nvix Neovim
module, replaced by the live-editable lazy.nvim config in `home/nvim`. To
switch back: re-add the `nixvim` and `nvix` flake inputs in `flake.nix`
(uncomment them, restore them in the outputs destructuring and the `inherit`
passes into the hosts imports), restore the `nixvim`/`nvix` parameters and the
`nixvim-config` sharedModules wiring in `hosts/*.nix` (see git history of this
directory's move commit), and drop the `"${self}/home/nvim"` import.
