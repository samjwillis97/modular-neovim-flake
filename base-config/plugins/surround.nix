{
  plugins.vim-surround = {
    enable = true;

    # Load on VeryLazy for surround operations
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };
  };
}
