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
  };
}
