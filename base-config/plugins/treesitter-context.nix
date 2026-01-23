{
  plugins.treesitter-context = {
    enable = true;

    # Load when reading a buffer
    lazyLoad.settings = {
      event = "BufRead";
    };

    settings = {
      line_numbers = true;
      max_lines = 10;
      multiline_threshold = 5;
    };
  };
}
