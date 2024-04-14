{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.bash;

  defaultServer = "bash-language-server";
  servers = {
    bash-language-server = {
      package = pkgs.nodePackages.bash-language-server;
      lspConfig = ''
        lspconfig.bashls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/bash-language-server", "start"}
        }
      '';
    };
  };
in
{
  options.vim.languages.bash = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "bash language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable bash treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "bash";
    };

    lsp = {
      enable = mkOption {
        description = "Enable bash LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "bash LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "bash LSP server package";
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
      vim.lsp.lspconfig.sources.bash-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
