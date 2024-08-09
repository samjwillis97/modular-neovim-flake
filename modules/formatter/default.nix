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

    setups = mkOption {
      description = "formatter setups";
      type = with types; attrsOf str;
      default = { };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.startPlugins = [ "conform-nvim" ];

      vim.luaConfigRC.formatter-setup-start = nvim.dag.entryAfter [ "formatter" ] ''
        require("conform").setup({
          formatters_by_ft = {
            ${concatLines (mapAttrsToList (_: v: v) cfg.fileTypes)}
          },
          formatters = {
            ${concatLines (mapAttrsToList (_: v: v) cfg.setups)}
          },
        })

        ${optionalString cfg.formatOnSave ''
          local formatAutoGroup = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            group = formatAutogroup,
            callback = function(args)
              require("conform").format({ bufnr = args.buf })
            end,
          })
        ''}
      '';
    }
  ]);
}
