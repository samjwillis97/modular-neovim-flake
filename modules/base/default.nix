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
  };

  config = {
    # vim.startPlugins = ["plenary-nvim"];
    vim.luaConfigRC.base = nvim.dag.entryAfter [ "globalsScript" ] ''
      -- Settings that are set for everything
      ${optionalString (cfg.leaderKey == "backslash") ''
        vim.g.mapleader = "\\"
      ''}

      ---- Leader Key
      ${optionalString (cfg.leaderKey == "space") ''
        vim.g.mapleader = "<space>"
      ''}

      ---- Line Numbering
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

      ---- Error Bell
       ${
         optionalString
         (cfg.errorBell == "visual" || cfg.errorBell == "both") ''
           vim.opt.visualbell = true
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
