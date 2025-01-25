{
  imports = [
    ./fidget.nix
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

        ts_ls.enable = true;
      };
    };
  };
}
