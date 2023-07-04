{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.qol;
in {
  imports = [ ./autopairs.nix ./lastplace.nix ./colorizer.nix ];
  options.vim.qol = { enable = mkEnableOption "qol"; };
}
