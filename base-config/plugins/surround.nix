{
  plugins.vim-surround = {
    enable = true;

    # Load only when using surround operations
    lazyLoad.settings = {
      keys = [
        "ys"
        "ds"
        "cs"
        "yS"
        "cS"
      ];
    };
  };
}
