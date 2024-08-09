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
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.startPlugins = [ "nvim-lint" ];

      vim.luaConfigRC.lintStart= nvim.dag.entryAnywhere ''
        local lint = require('lint')
        lint.linters_by_ft = {
      '';
    }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryBetween [ "lintEnd" ] [ "lintStart" ] v)) cfg.fileTypes;
    }
    {
      vim.luaConfigRC.lintEnd= nvim.dag.entryAfter [ "lintStart" ] ''
        }

        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
          group = lint_augroup,
          callback = function()
            lint.try_lint()
          end,
        })

        -- FIXME: doesn't work
        vim.api.nvim_create_user_command(
          "Linters", 
          function()
            local linters = lint.get_running()
            if #linters == 0 then
              print("󰦕")
              return
            end
            print("󱉶 " .. table.concat(linters, ", "))
            return
          end,
          {}
        )
      '';
    }
  ]);
}
