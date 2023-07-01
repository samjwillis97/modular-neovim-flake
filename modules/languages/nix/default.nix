{ pkgs, config, lib, ... }:
with lib;
with builtins;
let cfg = config.vim.languages.nix;
in {
  options.vim.languages.nix = {
    enable = mkEnableOption "Nix language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Nix treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "nix";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # TODO: Lua-fy this bitch
    # {
    #   vim.configRC.nix = nvim.dag.entryAnywhere ''
    #     autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
    #   '';
    # }

    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })
  ]);
}
