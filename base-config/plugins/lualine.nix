{
  plugins.lualine = {
    enable = true;

    # Load after startup for statusline
    lazyLoad.settings = {
      event = "VeryLazy";
    };

    settings = {
      options = {
        theme = "catppuccin";
      };
    };
  };
}
