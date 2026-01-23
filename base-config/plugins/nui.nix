{
  plugins.nui = {
    enable = true;

    # Load on VeryLazy as a dependency library for other plugins
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };
  };
}
