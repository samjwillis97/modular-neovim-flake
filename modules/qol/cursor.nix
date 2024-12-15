{ lib, config, ... }:
with lib;
with builtins;
let
  qolEnabled = config.vim.qol.enable;
  cfg = config.vim.qol.cursor;
in
{
  options.vim.qol.cursor = {
    smear = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable cursor smear - smooths out cursor movement";
      };
    };
  };

  config = mkIf qolEnabled (mkMerge [
    (mkIf cfg.smear.enable {
      vim.startPlugins = [ "smear-cursor" ];
      vim.luaConfigRC.smear-cursor = nvim.dag.entryAnywhere ''
        require('smear_cursor').setup({
          cursor_color = "none",
          legacy_computing_symbols_support = true,
        })
      '';
    })
  ]);
}
