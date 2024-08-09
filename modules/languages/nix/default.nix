{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.nix;

  defaultServer = "nil";
  servers = {
    nil = {
      package = pkgs.nil;
      internalFormatter = true;
      lspConfig = ''
        lspconfig.nil_ls.setup{
          handlers = handlers,
          capabilities = capabilities,
          on_attach = default_on_attach,
          cmd = {"${cfg.lsp.package}/bin/nil"},
        }
      '';
    };
  };

  defaultFormat = "nixfmt";
  formats = {
    alejandra = {
      package = pkgs.alejandra;
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.alejandra.with({
            command = "${cfg.format.package}/bin/alejandra"
          })
        )
      '';
    };
    nixpkgs-fmt = {
      package = pkgs.nixpkgs-fmt;
      formatterHandler = ''
        nix = {
          function()
            return {
              exe = "${cfg.format.package}/bin/nixpkgs-fmt",
              stdin = true,
              args = {},
            }
          end,
        },
      '';
    };
    nixfmt = {
      package = pkgs.nixfmt-rfc-style;
      formatterHandler = ''
        nix = {
          function()
            return {
              exe = "${cfg.format.package}/bin/nixfmt",
              stdin = true,
              args = {},
            }
          end,
        },
      '';
    };
  };
in
{
  options.vim.languages.nix = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "Nix language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Nix treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "nix";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Nix LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Nix LSP server to use";
        type = types.enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Nix LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Nix formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Nix formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Nix formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };

    linting = {
      enable = mkOption {
        description = "Enable linter";
        type = types.bool;
        default = config.vim.languages.enableLinting;
      };
      linters = mkOption {
        description = "Linters to use";
        type = with types; listOf str;
        default = [ "nix" ];
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.luaConfigRC.nix = nvim.dag.entryAnywhere ''
        vim.api.nvim_create_autocmd(
          { "FileType" },
          {
            pattern = "nix",
            command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2]],
          }
        )

        vim.api.nvim_create_autocmd(
          { "FileType" },
          {
            pattern = "nix",
            command = [[setlocal commentstring=#\ %s]],
          }
        )
      '';
    }

    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.nix-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    # (mkIf cfg.format.enable {
    #   vim.formatter.enable = true;
    #   vim.formatter.fileTypes.nix = formats.${cfg.format.type}.formatterHandler;
    # })

    (mkIf cfg.linting.enable {
      vim.linting.enable = true;
      vim.linting.fileTypes.nix = "nix = {${
        builtins.concatStringsSep "," (builtins.map (v: "'${v}'") cfg.linting.linters)
      }},";
    })
  ]);
}
