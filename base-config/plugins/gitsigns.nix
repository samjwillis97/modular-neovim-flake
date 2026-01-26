{
  keymaps = [
    {
      key = "[g";
      action = "<CMD>Gitsigns prev_hunk<CR>";
      options.desc = "Go to previous git change";
    }
    {
      key = "]g";
      action = "<CMD>Gitsigns next_hunk<CR>";
      options.desc = "Go to next git change";
    }
    {
      key = "<leader>gb";
      action = "<CMD>lua require('gitsigns').blame_line{full=true}<CR>";
      options.desc = "Show git blame for line";
    }
  ];

  plugins.gitsigns = {
    enable = true;

    # Load after buffer is read to show git signs
    lazyLoad.settings = {
      event = "BufReadPost";
      keys = [
        "[g"
        "]g"
        "<leader>gb"
      ];
    };
  };
}
