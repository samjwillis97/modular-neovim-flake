{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.qol;
in
{
  options.vim.qol.lastplace = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable last place - reopens files at last edit position";
    };

    ignoreBufTypes = mkOption {
      type = types.listOf types.str;
      default = [
        "quickfix"
        "nofile"
        "help"
      ];
      description = "Types of buffers to not use lastplace";
    };

    ignoreFileTypes = mkOption {
      type = types.listOf types.str;
      default = [
        "gitcommit"
        "gitrebase"
        "svn"
        "hgcommit"
      ];
      description = "Types of files to not use lastplace";
    };
  };

  config = mkIf (cfg.enable && cfg.lastplace.enable) {
    vim.startPlugins = [ "nvim-lastplace" ];
    vim.luaConfigRC.lastplace = nvim.dag.entryAnywhere ''
      require('nvim-lastplace').setup(
          {
            lastplace_ignore_buftype = {"${concatStringsSep ''", "'' cfg.lastplace.ignoreBufTypes}"},
            lastplace_ignore_filetype = {"${concatStringsSep ''", "'' cfg.lastplace.ignoreFileTypes}"},
            lastplace_open_folds = true,
          }
      )'';
  };
}
