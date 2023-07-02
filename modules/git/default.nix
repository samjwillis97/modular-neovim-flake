{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.git;
in {
  options.vim.git = {
    enable = mkEnableOption "git";

    gutterSigns = mkOption {
      type = types.bool;
      default = true;
      description = "Enable git indicators in the column gutter";
    };

    gitInterface = mkOption {
      type = types.enum [ "fugitive" "none" ];
      default = "fugitive";
      description = "Enable a git interface inside neovim";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins =
      if (cfg.gitInterface != "none") then [ cfg.gitInterface ] else [ ];

    vim.nnoremap = if (cfg.gitInterface == "fugitive") then {
      "<leader>gg" = ":Git<CR>";
    } else
      { };
  };
}
