{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.linting;
in 
{
  options.vim.linting = {
    enable = mkEnableOption "linting";

    fileTypes = mkOption {
      description = "linters by filetype";
      type = with types; attrsOf str;
      default = { };
    };

    lintAfterWrite = mkOption {
      description  = "Enable linting after write via. autocmd";
      type = types.bool;
      default = false;
    };
  };
  
  config = mkIf cfg.enable (mkMerge [
    {
      vim.startPlugins = [ "nvim-lint" ];

      vim.luaConfigRC.lintStart= nvim.dag.entryAnywhere ''
        require('lint').linters_by_ft = {
      '';
    }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryBetween [ "lintEnd" ] [ "lintStart" ] v)) cfg.fileTypes;
    }
    {
      vim.luaConfigRC.lintEnd= nvim.dag.entryAfter [ "lintStart" ] ''
        }
        ${optionalString (cfg.lintAfterWrite) ''
          vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
              require("lint").try_lint()
            end,
          })
        ''}
      '';
    }
  ]);
}
