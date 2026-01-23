{
  plugins.tmux-navigator = {
    enable = true;

    # Load on VeryLazy for navigation
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };
  };
}
