{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.qol;
in
{
  imports = [
    ./autopairs.nix
    ./lastplace.nix
    ./colorizer.nix
    ./undotree.nix
    ./harpoon.nix
    ./tmux-navigator.nix
    ./sneak.nix
  ];
  options.vim.qol = {
    enable = mkEnableOption "qol";
  };
}
