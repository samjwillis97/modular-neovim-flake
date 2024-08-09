{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.svelte;

  defaultServer = "svelte-language-server";
  servers = {
    svelte-language-server = {
      package = pkgs.nodePackages.svelte-language-server;
      lspConfig = ''
        lspconfig.svelte.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${cfg.lsp.package}/bin/svelteserver", "--stdio"}
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
        svelte = {
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
  options.vim.languages.svelte = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "Svelte language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Svelte treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "svelte";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Svelte LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Svelte LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Svelte LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Svelte formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Svelte formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Svelte formatter package";
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
      vim.lsp.lspconfig.sources.svelte-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    # (mkIf cfg.format.enable {
    #   vim.formatter.enable = true;
    #   vim.formatter.fileTypes.svelte = formats.${cfg.format.type}.formatterHandler;
    # })
  ]);
}
