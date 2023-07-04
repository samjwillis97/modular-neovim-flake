{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.qol;
in {
  options.vim.qol.harpoon = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables harpoon";
    };
  };

  config = mkIf (cfg.enable && cfg.harpoon.enable) {
    vim.startPlugins = [ "harpoon" ];
    vim.nnoremap = {
      "<leader>hf" = ":lua require('harpoon.mark').add_file()<CR>";
      "<leader>hh" = ":lua require('harpoon.ui').toggle_quick_menu()<CR>";
      "<leader>h1" = ":lua require('harpoon.ui').nav_file(1)<CR>";
      "<leader>h2" = ":lua require('harpoon.ui').nav_file(2)<CR>";
      "<leader>h3" = ":lua require('harpoon.ui').nav_file(3)<CR>";
      "<leader>h4" = ":lua require('harpoon.ui').nav_file(4)<CR>";
    };
  };
}
