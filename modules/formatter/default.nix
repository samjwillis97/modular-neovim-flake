{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.formatter;
  requiredFormatterSetups = lib.unique (builtins.concatLists (builtins.attrValues cfg.perFileType));
  availableFormatters = {
    prettier = ''
      function(bufnr)
        local cwd = vim.fn.getcwd()
        local prettierExists = vim.fn.executable('prettier') == 1
        if prettierExists == true then
          prettierScript = "prettier"
        else
          prettierScript = "${pkgs.nodePackages.prettier}/bin/prettier"
        end
        return {
          command = prettierScript,
        }
      end'';
    nixfmt = ''
      {
        command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt",
      }'';
  };
in
{
  options.vim.formatter = {
    enable = mkEnableOption "formatter";

    formatOnSave = mkOption {
      type = types.bool;
      default = true;
      description = "Format files on save";
    };

    perFileType = mkOption {
      description = "formatter handler per fileType";
      type = with types; attrsOf (listOf str);
      default = { };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.startPlugins = [ "conform-nvim" ];

      vim.luaConfigRC.formatter-setup-start = nvim.dag.entryAfter [ "formatter" ] ''
        require("conform").setup({
          formatters_by_ft = {
            ${
              concatLines (
                mapAttrsToList (
                  name: value:
                  "${name} = { ${
                    builtins.concatStringsSep "," (builtins.map (v: "'${v}'") value)
                  }, stop_after_first = true },"
                ) cfg.perFileType
              )
            }
          },
          formatters = {
            ${
              concatLines (
                builtins.map (
                  v:
                  if ((lib.hasAttr v availableFormatters) == true) then
                    ''
                      ${v} = ${availableFormatters.${v}},
                    ''
                  else
                    ""
                ) requiredFormatterSetups
              )
            }
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
