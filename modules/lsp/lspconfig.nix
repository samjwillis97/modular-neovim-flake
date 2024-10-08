{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.vim.lsp;
  visualCfg = config.vim.visuals;
  ufoFoldEnabled = config.vim.folding.mode == "ufo";
  borderType = visualCfg.borderType;
in
{
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
      vim.luaConfigRC.lspconfig = nvim.dag.entryAfter [ "lsp-setup" ] ''
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { 
          ${optionalString (borderType != null) ''border = "${borderType}",''}
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { 
          ${optionalString (borderType != null) ''border = "${borderType}",''}
        })

        local lspconfig = require("lspconfig")
      '';
    }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryAfter [ "lspconfig" ] v)) cfg.lspconfig.sources;
    }
    {
      vim.luaConfigRC.ufo-lspconfig = mkIf ufoFoldEnabled (
        nvim.dag.entryAfter [ "lspconfig" ] ''
          require('ufo').setup()
        ''
      );
    }
  ]);
}
