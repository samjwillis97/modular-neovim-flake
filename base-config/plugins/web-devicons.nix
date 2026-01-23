{
  plugins.web-devicons = {
    enable = true;

    # Load on VeryLazy as a dependency for other plugins
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };
  };
}
