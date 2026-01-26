{
  plugins.lastplace = {
    enable = true;

    # Load before reading a buffer to restore cursor position
    lazyLoad.settings = {
      event = "BufReadPre";
    };
  };
}
