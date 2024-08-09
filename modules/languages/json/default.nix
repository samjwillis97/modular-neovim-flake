{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.json;

  defaultServer = "vscode-language-server";
  servers = {
    vscode-language-server = {
      package = pkgs.nodePackages.vscode-json-languageserver;
      lspConfig = ''
        lspconfig.jsonls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/json-languageserver", "--stdio"}
        }
      '';
    };
  };
in
{
  options.vim.languages.json = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "JSON language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable JSON treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "json";
    };

    lsp = {
      enable = mkOption {
        description = "Enable JSON LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "JSON LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "JSON LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      types = mkOption {
        description = "Formatters to use";
        type = with types; listOf str;
        default = [ "prettier" ];
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
      vim.lsp.lspconfig.sources.json-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.formatter.enable = true;
      vim.formatter.perFileType = {
        json = cfg.format.types;
      };
    })
  ]);
}
