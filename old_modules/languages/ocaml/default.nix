{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.ocaml;

  defaultServer = "ocamllsp";
  servers = {
    ocamllsp = {
      package = pkgs.ocamlPackages.ocaml-lsp;
      internalFormatter = true;
      lspConfig = ''
        lspconfig.ocamllsp.setup{
          cmd = {"${cfg.lsp.package}/bin/ocamllsp"},
        }
      '';
    };
  };
in
{
  options.vim.languages.ocaml = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "OCaml language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable OCaml treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "ocaml";
    };

    lsp = {
      enable = mkOption {
        description = "Enable OCaml LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "OCaml LSP server to use";
        type = types.enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "OCaml LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.ocamllsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
