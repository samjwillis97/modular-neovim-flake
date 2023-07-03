{ config, lib, ... }:
with lib;
with builtins;
let cfg = config.vim.lsp;
in {
  options.vim.lsp.lspconfig = {
    enable = mkEnableOption "lspconfig, can be enabled automatically";

    sources = mkOption {
      description = "nvim-lspconfig sources";
      type = with types; attrsOf str;
      default = { };
    };
  };

  config = mkIf (cfg.enable && cfg.lspconfig.enable) (mkMerge [
    {
      vim.startPlugins = [ "lspconfig" ];
      vim.luaConfigRC.lspconfig = nvim.dag.entryAfter ["lsp-setup"] ''
        local lspconfig = require("lspconfig")
      '';
    }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryAfter [ "lspconfig" ] v))
        cfg.lspconfig.sources;
    }
  ]);
}
