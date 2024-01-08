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
        default = "│";
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

      highlightCurrentContext = mkOption {
        type = types.bool;
        default = false;
        description = "Highlight current conext from treesitter";
      };

      useTreesitter = mkOption {
        type = types.bool;
        default = true;
        description = "Use treesiter for indentation";
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

        require("ibl").setup({
          indent = {
            char = "${cfg.indentations.lineChar}",
          },
          scope = {
            show_end = ${
              boolToString (cfg.indentations.endChar != null)
            },
            show_exact_scope = ${
              boolToString (cfg.indentations.highlightCurrentContext)
            },
            show_start = ${
              boolToString (cfg.indentations.highlightCurrentContext)
            },
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
