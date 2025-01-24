{
  keymaps = [
    {
      key = "jk";
      mode = "i";
      action = "<Esc>";
    }
    # Enable this for <space> as leader
    # {
    #   key = "<space>";
    #   action = "<nop>";
    #   options.desc = "Leader key";
    # }
    {
      key = "j";
      action = "gj";
      options.desc = "Move down by visual line";
    }
    {
      key = "k";
      action = "gk";
      options.desc = "Move up by visual line";
    }
    {
      key = "<C-J>";
      action = "<C-W><C-J>";
      options.desc = "Move to window below";
    }
    {
      key = "<C-K>";
      action = "<C-W><C-K>";
      options.desc = "Move to window above";
    }
    {
      key = "<C-L>";
      action = "<C-W><C-L>";
      options.desc = "Move to window right";
    }
    {
      key = "<C-H>";
      action = "<C-W><C-H>";
      options.desc = "Move to window left";
    }
    {
      key = "<C-U>";
      action = "<C-U>zz";
    }
    {
      key = "<C-D>";
      action = "<C-D>zz";
    }
    {
      key = "<C-I>";
      action = "<C-I>zz";
    }
    {
      key = "<C-O>";
      action = "<C-O>zz";
    }
    {
      key = "n";
      action = "nzz";
    }
    {
      key = "N";
      action = "Nzz";
    }
    {
      key = "GG";
      action = "GGzz";
    }
  ];
}
