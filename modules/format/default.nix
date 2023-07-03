{ lib, config, ... }:
with lib;
with builtins; {
  imports = [ ];
  options.vim.format = { enable = mkEnableOption "format"; };
}
