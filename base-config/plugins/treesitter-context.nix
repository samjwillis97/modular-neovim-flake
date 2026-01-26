{
  highlightOverride = {
    "TreesitterContextBottom" = {
      underline = false;
    };
    "TreesitterContextLineNumberBottom" = {
      underline = false;
    };
  };

  plugins.treesitter-context = {
    enable = true;

    # Load after buffer is read (after treesitter)
    lazyLoad.settings = {
      event = "BufReadPost";
    };

    settings = {
      line_numbers = true;
      max_lines = 10;
      multiline_threshold = 5;
    };
  };
}
