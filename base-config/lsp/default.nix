{
  imports = [
    # ./fidget.nix
  ];

  keymaps = [
    {
      key = "[d";
      action = "<CMD>lua vim.diagnostic.goto_prev()<CR>";
    }
    {
      key = "]d";
      action = "<CMD>lua vim.diagnostic.goto_next()<CR>";
    }
  ];

  plugins = {
    lsp = {
      enable = true;

      lazyLoad.settings = {
        event = "BufReadPre";
      };

      keymaps = {
        lspBuf = {
          "gD" = "declaration";
          "K" = "hover";
          "<leader>k" = "signature_help";
          "<leader>t" = "type_definition";
          "<leader>r" = "rename";
        };
      };

      # No servers enabled by default - users add their own
      servers = {
        # Example: Enable language servers in your extension
        # nil_ls.enable = true;
        # ts_ls.enable = true;
        # rust_analyzer.enable = true;
      };

      luaConfig = {
        post = ''
          -- Diagnostics are configured via vim.diagnostic.config() now; the
          -- "textDocument/publishDiagnostics" handler is installed automatically.
          vim.diagnostic.config({
            underline = true,
            signs = true,
            update_in_insert = false,
          })

          -- Border for floating windows (hover, signature help, etc.).
          -- Replaces the deprecated vim.lsp.with() handler overrides.
          vim.o.winborder = "single"
        '';
      };
    };
  };
}
