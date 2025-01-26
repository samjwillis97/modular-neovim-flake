{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.qol;
in
{
  options.vim.qol.undotree = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable undotree - see changes to files in a tree";
    };
  };

  config = mkIf (cfg.enable && cfg.undotree.enable) {
    vim.undoFiles.enable = true;

    vim.telescope.enable = true;
    vim.telescope.undo.enable = true;
  };
}
