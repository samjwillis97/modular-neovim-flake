{
  plugins.lualine = {
    enable = true;

    # Load after startup for statusline
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };

    settings = {
      options = {
        theme = "catppuccin";
      };
    };
  };
}
