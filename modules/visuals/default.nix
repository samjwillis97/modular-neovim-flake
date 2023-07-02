{ config, lib, ... }:
with lib;
with builtins;
let cfg = config.vim.visuals;
in {
  options.vim.visuals = {
    enable = mkEnableOption "visual enhancements";

    betterIcons = mkOption {
      type = types.bool;
      default = true;
      description = "Better file icons etc.";
    };

    indentations = { };
  };

  config = mkIf cfg.enable (mkMerge
    [ (mkIf cfg.betterIcons { vim.startPlugins = [ "nvim-web-devicons" ]; }) ]);
}
