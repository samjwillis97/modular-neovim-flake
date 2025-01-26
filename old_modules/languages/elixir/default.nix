{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.elixir;

  defaultServer = "elixirls";
  servers = {
    elixirls = {
      package = pkgs.elixir-ls;
      internalFormatter = true;
      lspConfig = ''
        lspconfig.elixirls.setup{
          capabilities = capabilities,
          on_attach = default_on_attach,
          cmd = {"${cfg.lsp.package}/bin/elixir-ls"},
        }
      '';
    };
  };
in
{
  options.vim.languages.elixir = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "Elixir language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Elixir treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "elixir";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Elixir LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Elixir LSP server to use";
        type = types.enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Elixir LSP server package";
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
      vim.lsp.lspconfig.sources.elixir-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
