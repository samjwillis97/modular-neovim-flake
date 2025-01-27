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

        ts_ls.enable = true;
        eslint.enable = true;
        svelte.enable = true;

        pyright.enable = true;

        jsonls.enable = true;
        yamlls.enable = true;
      };
    };
  };
}
