{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.vim.languages.typescript;

  enabledServerConfigs = listToAttrs (map (v: { name = v; value = servers.${v}.lspConfig; }) cfg.lsp.servers);
  enabledServerPackages = listToAttrs (map (v: { name = v; value = servers.${v}.package; }) cfg.lsp.servers);

  defaultServers = [ "tsserver" ];
  servers = {
    tsserver = {
      package = pkgs.nodePackages.typescript-language-server;
      lspConfig = ''
        lspconfig.tsserver.setup {
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = { "${enabledServerPackages.tsserver}/bin/typescript-language-server", "--stdio" }
        }
      '';
    };
    # FIXME: This doesn't actually exist - trying to add it though, cannot execute see: 
    # https://github.com/angular/vscode-ng-language-service/issues/1899
    angularls = {
      package = pkgs.nodePackages."@angular/language-server";
      lspConfig = ''
        lspconfig.angularls.setup {
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = { "${enabledServerPackages.angularls}/bin/ngserver"}
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

  defaultDiagnostics = [ "eslint" ];
  diagnostics = {
    eslint = {
      package = pkgs.nodePackages.eslint;
      nullConfig = pkg: ''
        table.insert(
          ls_sources,
          null_ls.builtins.diagnostics.eslint.with({
            command = "${pkg}/bin/eslint",
          })
        )
      '';
    };
  };
in
{
  options.vim.languages.typescript = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "Typescript language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Typescript treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      tsPackage = nvim.types.mkGrammarOption pkgs "typescript";
      jsPackage = nvim.types.mkGrammarOption pkgs "javascript";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Typescript LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      servers = mkOption {
        description = "Typescript LSP servers to use";
        type = types.listOf (types.enum (attrNames servers));
        default = defaultServers;
      };
      packages = mkOption {
        description = "Typescript LSP server packages";
        type = types.listOf types.package;
        default = map (v: servers.${v}.package) cfg.lsp.servers;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Typescript formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Typescript formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Typescript formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };

    extraDiagnostics = {
      enable = mkOption {
        description = "Enable extra Typescript diagnostics";
        type = types.bool;
        default = config.vim.languages.enableExtraDiagnostics;
      };
      types = lib.nvim.types.diagnostics {
        langDesc = "Typescript";
        inherit diagnostics;
        inherit defaultDiagnostics;
      };
    };

  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.luaConfigRC.nix = nvim.dag.entryAnywhere ''
        vim.api.nvim_create_autocmd(
          { "FileType" },
          {
            pattern = "ts",
            command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2]],
          }
        )

        vim.api.nvim_create_autocmd(
          { "FileType" },
          {
            pattern = "js",
            command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2]],
          }
        )
      '';
    }

    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars =
        [ cfg.treesitter.tsPackage cfg.treesitter.jsPackage ];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;

      vim.lsp.lspconfig.sources = enabledServerConfigs;
    })

    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.ts-format = formats.${cfg.format.type}.nullConfig;
    })

    (mkIf cfg.extraDiagnostics.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources = lib.nvim.languages.diagnosticsToLua {
        lang = "ts";
        config = cfg.extraDiagnostics.types;
        inherit diagnostics;
      };
    })
  ]);
}
