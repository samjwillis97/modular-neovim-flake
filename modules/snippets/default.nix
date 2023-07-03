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

  # FIXME: Does this even work...
  config = mkIf cfg.vsnip.enable {
    vim.startPlugins = [ "vim-vsnip" ];
  };
}
