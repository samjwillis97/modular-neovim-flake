{ config, lib, ... }:
with lib;
with builtins;
let cfg = config.vim.visuals;
in {
  options.vim.visuals = {
    enable = mkEnableOption "visual enhancements";

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
        default = true;
        description = "Highlight current conext from treesitter";
      };

      useTreesitter = mkOption {
        type = types.bool;
        default = true;
        description = "Use treesiter for indentation";
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

        require("indent_blankline").setup({
            char = "${cfg.indentations.lineChar}",
            show_end_of_line = ${
              boolToString (cfg.indentations.endChar != null)
            },
            use_treesitter = ${boolToString (cfg.indentations.useTreesitter)},
            show_current_context = ${
              boolToString (cfg.indentations.highlightCurrentContext)
            },
            show_current_context_start = ${
              boolToString (cfg.indentations.highlightCurrentContext)
            },
        })
      '';
    })
  ]);
}
