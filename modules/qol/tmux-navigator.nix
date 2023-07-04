{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.qol;
in {
  options.vim.qol.tmux-navigator = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable tmux navigation between vim splits and tmux";
    };
  };

  config = mkIf (cfg.enable && cfg.tmux-navigator.enable) {
    vim.startPlugins = [ "tmux-navigator" ];
  };
}
