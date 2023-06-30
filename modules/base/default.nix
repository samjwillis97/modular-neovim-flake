{ pkgs, lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim;
in {
  options.vim = {
    lineNumberMode = mkOption {
      type = with types; enum [ "relative" "number" "relNumber" "none" ];
      default = "relNumber";
      description =
        "How line numbers are displayed. none, relative, number, relNumber";
    };
  };

  config = {
    # vim.startPlugins = ["plenary-nvim"];
    vim.configRC.base = nvim.dag.entryAfter [ "globalsScript" ] ''
      " Settings that are set for everything
      ${optionalString (cfg.lineNumberMode == "relative") ''
        set relativenumber
      ''}
       ${
         optionalString (cfg.lineNumberMode == "number") ''
           set number
         ''
       }
       ${
         optionalString (cfg.lineNumberMode == "relNumber") ''
           set number relativenumber
         ''
       }
    '';
  };
}
