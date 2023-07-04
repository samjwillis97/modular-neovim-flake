{ lib, ... }:
with lib;
let
  mkEnable = desc:
    mkOption {
      description = "Turn on ${desc} for enabled languages by default";
      type = types.bool;
      default = false;
    };
in {
  imports = [ ./nix ./typescript ./html ./python ./go ./css ./svelte ];
  options.vim.languages = {
    enableAll = mkEnable "all Languages";
    enableLSP = mkEnable "LSP";
    enableTreesitter = mkEnable "treesitter";
    enableFormat = mkEnable "formatting";
    enableExtraDiagnostics = mkEnable "extra diagnostics";
  };
}
