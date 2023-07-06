{ pkgs, config, lib, ... }:
with lib;
with builtins; let
  cfg = config.vim.languages.terraform;
  defaultServer = "terraformls";
  servers = {
    terraformls = {
      package = pkgs.terraform-ls;
      lspConfig = ''
        lspconfig.terraformls.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/terraform-ls", "serve"},
        }
      '';
    };
  };
in
{
  options.vim.languages.terraform = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "Terraform language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Terraform treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "terraform";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Terraform LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Terraform LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Terraform LSP server package";
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
      vim.lsp.lspconfig.sources.terraform-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
