{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.formatter;
in
{
  options.vim.formatter = {
    enable = mkEnableOption "formatter";

    formatOnSave = mkOption {
      type = types.bool;
      default = true;
      description = "Format files on save";
    };

    fileTypes = mkOption {
      description = "formatter fileType handlers";
      type = with types; attrsOf str;
      default = { };
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    vim.startPlugins = [ "formatter-nvim" ];

    vim.luaConfigRC.formatter = ''
      local util = require("formatter.util")

      ${optionalString cfg.formatOnSave ''
        local formatAutoGroup = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePost", {
          command = "FormatWrite",
          pattern = "*",
          group = formatAutogroup
        })
      ''}
    '';

    vim.luaConfigRC.formatter-setup-start = nvim.dag.entryAfter [ "formatter" ] ''
      require("formatter").setup({
        filetype = {
    '';

    vim.luaConfigRC.formatter-setup-end = nvim.dag.entryAfter [ "formatter-setup-start" ] ''
        }
      })
    '';
  }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryBefore [ "formatter-setup-end" ] v)) cfg.fileTypes;
    }]);
}
