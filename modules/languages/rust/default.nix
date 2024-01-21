{ pkgs, config, lib, ... }:
with lib;
with builtins; let
  cfg = config.vim.languages.rust;

  defaultServer = "rust-analyzer";
  servers = {
    rust-analyzer = {
      package = pkgs.rust-analyzer;
      lspConfig = ''
        lspconfig.rust_analyzer.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = { "${cfg.lsp.package}/bin/rust-analyzer" }
        }
      '';
    };
  };
in
{
  options.vim.languages.rust = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "Rust language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Rust treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "rust";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Rust LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Rust LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Rust LSP server package";
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
      vim.lsp.lspconfig.sources.rustlsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
