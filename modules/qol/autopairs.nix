{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.qol.autopairs;
in {
  options.vim.qol.autopairs = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables autopairs";
    };

    # TODO: CMP
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ "autopairs" ];
    vim.luaConfigRC.autopairs =
      nvim.dag.entryAnywhere "require('nvim-autopairs').setup()";
  };
}
