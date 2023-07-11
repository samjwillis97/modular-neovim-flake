{ pkgs, config, lib, ... }:
with lib;
with builtins; let
  cfg = config.vim.languages.csharp;

  defaultServer = "omnisharp";
  servers = {
    omnisharp = {
      lspConfig = ''
        lspconfig.omnisharp.setup{
          capabilities = capabilities;
          on_attach = csharp_on_attach;
          cmd = {"${pkgs.dotnet-sdk}/bin/dotnet", "${pkgs.omnisharp-roslyn}/lib/omnisharp-roslyn/OmniSharp.dll"}
        }
      '';
    };
  };

  defaultFormat = "dotnet";
  formats = {
    dotnet = {
      package = pkgs.dotnet-sdk;
      formatterHandler = ''
        typescript = {
          function()
            return {
              exe = "${cfg.format.package}/bin/dotnet",
              args = {
                "format",
                "whitespace",
                "--include",
              },
              stdin = false,
            }
          end,
        },
      '';
    };
  };

in
{
  options.vim.languages.csharp = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "C# language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable C# treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "c_sharp";
    };

    lsp = {
      enable = mkOption {
        description = "Enable C# LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "C# LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable C# formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "C# formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "C# formatter package";
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
      vim.lsp.lspconfig.sources.csharp-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.formatter.enable = true;
      vim.formatter.fileTypes.csharp = formats.${cfg.format.type}.formatterHandler;
    })
  ]);
}
