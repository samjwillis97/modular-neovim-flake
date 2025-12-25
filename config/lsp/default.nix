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

      servers = {
        nil_ls.enable = true;
        # nixd.enable = true;

        bashls.enable = true;

        gopls.enable = true;

        lua_ls.enable = true;

        # Not supported lol
        # csharp_ls.enable = true;
        # omnisharp.enable = true;

        # denologs = false;
        ts_ls.enable = true;

        # # denols only activates in Deno projects (with deno.json or deno.jsonc)
        # denols = {
        #   enable = true;
        #   rootMarkers = [
        #     "deno.json"
        #     "deno.jsonc"
        #   ];
        #   extraOptions = {
        #     single_file_support = false;
        #   };
        # };

        # ts_ls - DISABLED here, manually configured in luaConfig to prevent conflicts
        # ts_ls = {
        #   enable = true;
        #   extraOptions = {
        #     single_file_support = false;
        #   };
        # };

        html.enable = true;
        eslint.enable = true;
        svelte.enable = true;

        pyright.enable = true;

        jsonls.enable = true;
        yamlls.enable = true;
      };

      luaConfig = {
        post = ''
          -- What does this do?
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
