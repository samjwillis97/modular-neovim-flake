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

    # Load when reading a buffer or using fold operations
    lazyLoad.settings = {
      event = "BufReadPost";
      keys = [
        "zR"
        "zM"
        "zo"
        "zc"
        "za"
        "zO"
        "zC"
        "zA"
      ];
    };
  };
}
