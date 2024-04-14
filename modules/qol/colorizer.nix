{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.qol;
in
{
  options.vim.qol.colorizer = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables colorizer";
    };
  };

  config = mkIf (cfg.enable && cfg.colorizer.enable) {
    vim.startPlugins = [ "colorizer" ];
    vim.luaConfigRC.colorizer = nvim.dag.entryAnywhere ''
      require('colorizer').setup()
    '';
  };
}
