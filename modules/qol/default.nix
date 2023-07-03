{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.qol;
in {
  imports = [ ./autopairs.nix ./lastplace.nix ];
  options.vim.qol = { enable = mkEnableOption "qol"; };
}
