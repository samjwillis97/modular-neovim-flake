{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.python;

  defaultServer = "pyright";
  servers = {
    pyright = {
      package = pkgs.pyright;
      lspConfig = ''
        lspconfig.pyright.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/pyright-langserver", "--stdio"}
        }
      '';
    };
  };

  defaultFormat = "black";
  formats = {
    black = {
      package = pkgs.black;
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.black.with({
            command = "${cfg.format.package}/bin/black",
          })
        )
      '';
      formatterHandler = ''
        python = {
          function()
            return {
              exe = "${cfg.format.package}/bin/black",
              args = { "-q", "-" },
              stdin = true,
            }
          end,
        },
      '';
    };
  };
in
{
  options.vim.languages.python = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "Python language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Python treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "python";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Python LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Python LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Python LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Python formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Python formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Python formatter package";
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
      vim.lsp.lspconfig.sources.python-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    # (mkIf cfg.format.enable {
    #   vim.formatter.enable = true;
    #   vim.formatter.fileTypes.python = formats.${cfg.format.type}.formatterHandler;
    # })
  ]);
}
