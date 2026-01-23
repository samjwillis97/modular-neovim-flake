{
  keymaps = [
    {
      key = "zR";
      action = "<CMD>lua require('ufo').openAllFolds()<CR>";
    }
    {
      key = "zM";
      action = "<CMD>lua require('ufo').closeAllFolds()<CR>";
    }
  ];

  plugins.nvim-ufo = {
    enable = true;

    # Load when reading a buffer for code folding
    lazyLoad.settings = {
      event = "BufRead";
    };
  };
}
