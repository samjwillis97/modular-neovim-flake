{
  plugins.colorizer = {
    enable = true;

    # Load when reading a buffer to colorize hex codes
    lazyLoad.settings = {
      event = "BufRead";
    };
  };
}
