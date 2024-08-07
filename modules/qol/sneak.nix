{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.qol;
in
{
  options.vim.qol.sneak = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables sneak";
    };

    # keys = {
    # forwardSneak = mkOption {
    #   default = "s";
    #   type = types.str;
    # };
    # backwardSneak = mkOption {
    #   default = "S";
    #   type = types.str;
    # };
    # nextMatch = mkOption {
    #   default = ";";
    #   type = types.str;
    # };
    # previousMatch = mkOption {
    #   default = ",";
    #   type = types.str;
    # };
    # };
  };

  config = mkIf (cfg.enable && cfg.sneak.enable) {
    vim.startPlugins = [ "vim-sneak" ];
    # vim.nnoremap = {
    #   "s" = ":NvimTreeFindFile<CR>";
    # };
  };
}
