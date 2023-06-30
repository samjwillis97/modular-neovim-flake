{ pkgs, lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim;
in {
  options.vim = {
    # TODO: Validate space binding
    leaderKey = mkOption {
      type = with types; enum [ "space" "backslash" ];
      default = "backslash";
      description = "Key to bind to leader";
    };

    errorBell = mkOption {
      type = with types; enum [ "visual" "sound" "both" "none" ];
      default = "none";
      description = "How to notify of errors messages";
    };

    lineNumberMode = mkOption {
      type = with types; enum [ "relative" "number" "relNumber" "none" ];
      default = "relNumber";
      description =
        "How line numbers are displayed. none, relative, number, relNumber";
    };

    colourTerm = mkOption {
      type = types.bool;
      default = true;
      description = "Set terminal up for 256 colours";
    };

    showCursorLine = mkOption {
      type = with types; bool;
      default = true;
      description = "Set to highlight the text line of the cursor";
    };

    signColumnMode = mkOption {
      type = with types; enum [ "always" "never" "auto" ];
      default = "always";
      description = "How to display the sign column";
    };

    cmdHeight = mkOption {
      type = with types; int;
      default = 1;
      description = "Height of the command bar";
    };

    scrollOffsetLines = mkOption {
      type = with types; int;
      default = 8;
      description =
        "The minimum amount of lines to be above or below the cursor line";
    };
  };

  config = {
    # vim.startPlugins = ["plenary-nvim"];
    vim.luaConfigRC.base = nvim.dag.entryAfter [ "globalsScript" ] ''
      -- Settings that are set for everything
      vim.opt.scrolloff = ${toString cfg.scrollOffsetLines}
      vim.opt.cmdheight = ${toString cfg.cmdHeight}

      ${optionalString (cfg.leaderKey == "backslash") ''
        vim.g.mapleader = "\\"
      ''}
      ${optionalString (cfg.leaderKey == "space") ''
        vim.g.mapleader = "<space>"
      ''}
       ${
         optionalString (cfg.lineNumberMode == "number" || cfg.lineNumberMode
           == "relNumber") ''
             vim.opt.number = true
           ''
       }
      ${optionalString
      (cfg.lineNumberMode == "relative" || cfg.lineNumberMode == "relNumber") ''
        vim.opt.relativenumber = true
      ''}
       ${
         optionalString (cfg.showCursorLine) ''
           vim.opt.cursorline = true
         ''
       }
       ${
         optionalString (cfg.signColumnMode == "always") ''
           vim.opt.signcolumn = "yes"
         ''
       }
       ${
         optionalString (cfg.signColumnMode == "auto") ''
           vim.opt.signcolumn = "auto"
         ''
       }
       ${
         optionalString
         (cfg.errorBell == "visual" || cfg.errorBell == "both") ''
           vim.opt.visualbell = true
         ''
       }
       ${
         optionalString (cfg.colourTerm) ''
           vim.opt.termguicolors = true
         ''
       }
       ${
         optionalString (cfg.errorBell == "sound" || cfg.errorBell == "both") ''
           vim.opt.errorbells = true
         ''
       }
    '';
  };
}
