{
  plugins.nvim-autopairs = {
    enable = true;

    # Load when entering insert mode
    lazyLoad.settings = {
      event = "InsertEnter";
    };
  };
}
