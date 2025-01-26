{
  keymaps = [
    {
      key = "<leader>gg";
      action = "<CMD>Git<CR>";
      options.desc = "Show fugitive interface";
    }
    {
      key = "<leader>gB";
      action = "<CMD>Git blame<CR>";
      options.desc = "Show git blame panel";
    }
  ];

  plugins.fugitive.enable = true;
}
