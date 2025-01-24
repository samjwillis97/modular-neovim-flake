let
  treeWidth = 35;
in
{
  keymaps = [
    {
      key = "<C-n>";
      action = "<CMD>NvimTreeToggle<CR>";
      options.desc = "Toggle NvimTree";
    }
    {
      key = ",n";
      action = "<CMD>NvimTreeFindFile<CR>";
      options.desc = "Go to current file in NvimTree";
    }
  ];

  plugins = {
    nvim-tree = {
      enable = true;

      view = {
        width = 35;
        float = {
          enable = true;
          openWinConfig.__raw = ''
            function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * 0.${toString (treeWidth)}
              local window_h = screen_h * 0.8
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2)
                               - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          '';

        };
      };

      actions = {
        windowPicker = {
          enable = true;
          chars = "JDKSLA";
        };
      };
    };
  };
}
