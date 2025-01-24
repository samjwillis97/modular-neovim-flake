{
  imports = [
    ./fidget.nix
  ];

  plugins = {
    lsp = {
      enable = true;

      servers = {
        nil_ls.enable = true;
        # nixd.enable = true;
        bashls.enable = true;
        ts_ls.enable = true;
      };
    };
  };
}
