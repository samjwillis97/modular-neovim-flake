{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.vim.visuals;
  lspEnabled = config.vim.lsp.enable;
in
{
  options.vim.visuals = {
    enable = mkEnableOption "visual enhancements";

    borderType = mkOption {
      type = types.enum [ "rounded" "normal" "none" ];
      default = "none";
      description = "Border styling on dialogs";
    };

    betterIcons = mkOption {
      type = types.bool;
      default = true;
      description = "Better file icons etc.";
    };

    indentations = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable indentation visual enhancements";
      };

      lineChar = mkOption {
        type = types.nullOr types.str;
        default = "▎";
        description = "Character for indentation line";
      };

      fillChar = mkOption {
        type = types.nullOr types.str;
        default = " ";
        description = "Character for filling indentations";
      };

      endChar = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Character at end of line";
      };

      highlightScope = mkOption {
        type = types.bool;
        default = true;
        description = "Highlight current scope";
      };
    };

    lspSpinner = {
      enable = mkOption {
        description = "enable lsp spinner";
        type = types.bool;
        default = config.vim.lsp.enable;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.betterIcons { vim.startPlugins = [ "nvim-web-devicons" ]; })
    (mkIf cfg.indentations.enable {
      vim.startPlugins = [ "indent-blankline" ];
      vim.luaConfigRC.indent-blankline = nvim.dag.entryAnywhere ''
        vim.opt.list = true

        ${optionalString (cfg.indentations.endChar != null) ''
          vim.opt.listchars:append({ eol = "${cfg.indentations.endChar}" })``
        ''}
        ${optionalString (cfg.indentations.fillChar != null) ''
          vim.opt.listchars:append({ space = "${cfg.indentations.fillChar}" })
        ''}

        ${optionalString (cfg.indentations.highlightScope) ''
        -- FIXME: Remove hard codes
        -- FIXME: Also do the cmp hl groups when doing that
        local hooks = require("ibl.hooks")
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)
        ''}

        require("ibl").setup({
          indent = {
            char = "${cfg.indentations.lineChar}",
          },
          scope = {
            -- TODO: Fix up the nix config above
            enabled = ${
              boolToString cfg.indentations.highlightScope
            },
            ${optionalString (cfg.indentations.highlightScope) ''
            show_exact_scope = true,
            show_start = false,
            show_end = false,
            highlight = {
              "RainbowViolet",
            },
            ''}
          },
        })
      '';
    })
    (mkIf (cfg.lspSpinner.enable && lspEnabled) {
      vim.startPlugins = [ "fidget" ];
      vim.luaConfigRC.fidget = nvim.dag.entryAnywhere ''
        require("fidget").setup{}
      '';
    })
  ]);
}
