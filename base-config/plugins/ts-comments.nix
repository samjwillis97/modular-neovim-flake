{
  plugins.ts-comments = {
    enable = true;

    # Load when reading a buffer for comment support
    lazyLoad.settings = {
      event = "BufRead";
    };
  };
}
