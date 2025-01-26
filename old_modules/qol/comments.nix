{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.qol;
in
{
  options.vim.qol.comments = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables better comments";
    };
  };

  config = mkIf (cfg.enable && cfg.comments.enable) {
    vim.startPlugins = [ "ts-comments" ];
    vim.luaConfigRC."ts-comments" = nvim.dag.entryAnywhere ''
      require('ts-comments').setup()
    '';
  };
}
