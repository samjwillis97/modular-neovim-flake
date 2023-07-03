{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.qol;
in {
  imports = [ ./autopairs.nix ];
  options.vim.qol = { enable = mkEnableOption "qol"; };
}
