{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.lua;

  defaultServer = "lua_ls";
  servers = {
    lua_ls = {
      package = pkgs.lua-language-server;
      lspConfig = ''
        lspconfig.lua_ls.setup{
          handlers = handlers,
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/lua-language-server"}
        }
      '';
    };
  };
in
{
  options.vim.languages.lua = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "lua language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable lua treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "lua";
    };

    lsp = {
      enable = mkOption {
        description = "Enable lua LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "lua LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "lua LSP server package";
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
      vim.lsp.lspconfig.sources.lua-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
