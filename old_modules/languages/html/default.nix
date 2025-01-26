{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.html;

  defaultServer = "vscode-language-server";
  servers = {
    vscode-language-server = {
      package = pkgs.nodePackages.vscode-langservers-extracted;
      lspConfig = ''
        lspconfig.html.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/vscode-html-language-server", "--stdio"}
        }
      '';
    };
  };
in
{
  options.vim.languages.html = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "HTML language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable HTML treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "html";

      autotagHtml = mkOption {
        description = "Enable autoclose/autorename of html tags (nvim-ts-autotag)";
        type = types.bool;
        default = true;
      };
    };

    lsp = {
      enable = mkOption {
        description = "Enable HTML LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "HTML LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "HTML LSP server package";
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

      vim.startPlugins = optional cfg.treesitter.autotagHtml "nvim-ts-autotag";

      vim.luaConfigRC.html-autotag = mkIf cfg.treesitter.autotagHtml (
        nvim.dag.entryAnywhere ''
          require('nvim-ts-autotag').setup()
        ''
      );
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.html-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.formatter.enable = true;
      vim.formatter.perFileType = {
        html = cfg.format.types;
      };
    })
  ]);
}
