{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.css;

  defaultServer = "vscode-language-server";
  servers = {
    vscode-language-server = {
      package = pkgs.nodePackages.vscode-langservers-extracted;
      lspConfig = ''
        lspconfig.cssls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/vscode-css-language-server", "--stdio"}
        }
      '';
    };
  };
in
{
  options.vim.languages.css = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "CSS language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable CSS treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "css";
    };

    lsp = {
      enable = mkOption {
        description = "Enable CSS LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "CSS LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "CSS LSP server package";
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
      vim.lsp.lspconfig.sources.css-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.formatter.enable = true;
      vim.formatter.perFileType = {
        css = cfg.format.types;
      };
    })
  ]);
}
