{ pkgs, ... }:
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

  plugins = {
    fugitive = {
      enable = true;

      # Lazy load on git commands and keymaps
      lazyLoad.settings = {
        cmd = "Git";
        keys = [
          "<leader>gg"
          "<leader>gB"
        ];
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [ vim-rhubarb ];
}
