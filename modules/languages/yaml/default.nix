{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.yaml;

  defaultServer = "yaml-language-server";
  servers = {
    yaml-language-server = {
      package = pkgs.nodePackages.yaml-language-server;
      lspConfig = ''
        lspconfig.yamlls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/yaml-language-server", "--stdio"}
        }
      '';
    };
  };
in
{
  options.vim.languages.yaml = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "YAML language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable YAML treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "yaml";
    };

    lsp = {
      enable = mkOption {
        description = "Enable YAML LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "YAML LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "YAML LSP server package";
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
      vim.lsp.lspconfig.sources.yaml-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.formatter.enable = true;
      vim.formatter.perFileType =
        {
          yaml = cfg.format.types;
        };
    })
  ]);
}
