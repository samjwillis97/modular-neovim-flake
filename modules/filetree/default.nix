{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.filetree;
in {
  options.vim.filetree = {
    enable = mkEnableOption "filetree";

    location = mkOption {
      type = types.enum [ "left" "right" "center" ];
      default = "left";
      description = "Where the tree will appear";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ "nvim-tree-lua" ];

    vim.nnoremap = {
      "<C-n>" = ":NvimTreeToggle<CR>";
      ",n" = ":NvimTreeFindFile<CR>";
    };

    vim.luaConfigRC.filetree = nvim.dag.entryAnywhere ''
      require("nvim-tree").setup({})
    '';
  };
}
