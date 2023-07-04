{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.vim.languages.css;

  defaultServer = "vscode-language-server";
  servers = {
    vscode-language-server = {
      package = pkgs.nodePackages.vscode-css-languageserver-bin;
      lspConfig = ''
        lspconfig.cssls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/css-languageserver", "--stdio"}
        }
      '';
    };
  };

  defaultFormat = "prettier";
  formats = {
    prettier = {
      package = pkgs.nodePackages.prettier;
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.prettier.with({
            command = "${cfg.format.package}/bin/prettier",
          })
        )
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
        description = "Enable CSS formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "CSS formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "CSS formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
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
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.css-format =
        formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
