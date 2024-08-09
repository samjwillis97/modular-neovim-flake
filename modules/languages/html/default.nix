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
      formatterHandler = ''
        html = {
          function()
            local cwd = vim.fn.getcwd()
            local prettierExists = vim.fn.executable('prettier') == 1
            if prettierExists == true then
              prettierScript = "${cfg.format.package}/bin/prettier"
            else
              prettierScript = "prettier"
            end
            return {
              exe = prettierScript,
              args = {
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
              },
              stdin = true,
              try_node_modules = true,
            }
          end,
        },
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
        description = "Enable HTML formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "HTML formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "HTML formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
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
      vim.formatter.fileTypes.html = formats.${cfg.format.type}.formatterHandler;
    })
  ]);
}
