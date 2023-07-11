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
  ]);
}
