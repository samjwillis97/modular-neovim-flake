{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.qol;
in
{
  options.vim.qol.quickfix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable quicker.nvim to improve quickfix";
    };
  };

  config = mkIf (cfg.enable && cfg.quickfix.enable) {
    vim.startPlugins = [ "quicker" ];
    vim.luaConfigRC.quicker = nvim.dag.entryAnywhere ''
      require('quicker').setup({
      })
    '';
  };
}
