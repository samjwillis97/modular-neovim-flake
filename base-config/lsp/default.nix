{
  imports = [
    ./fidget.nix
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
        pre = ''
          -- Function to get LSP capabilities with blink-cmp support
          local __lspCapabilities = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- Try to load blink-cmp capabilities if available
            local has_blink, blink = pcall(require, 'blink-cmp')
            if has_blink then
              capabilities = vim.tbl_deep_extend('force', capabilities, blink.get_lsp_capabilities())
            end

            return capabilities
          end

          -- Store for later use by LSP servers
          vim.g.__lspCapabilities = __lspCapabilities
        '';

        post = ''
          vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
              underline = true,
              signs = true,
              update_in_insert = false,
            }
          )

          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
              border = "single",
            }
          )

          vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
              border = "single",
            }
          )
        '';
      };
    };
  };
}
