{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.snippets;
in {
  options.vim.snippets = {
    vsnip = {
      enable = mkEnableOption "vsnip";
    };
  };

  config = mkIf cfg.vsnip.enable {
    vim.startPlugins = [ "vim-vsnip" ];
  };
}
