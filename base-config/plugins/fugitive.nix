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
    {
      key = "<leader>go";
      action = "<CMD>GBrowse<CR>";
      mode = [ "n" "v" ];
      options.desc = "Open in GitHub";
    }
    {
      key = "<leader>gy";
      action = "<CMD>GBrowse!<CR>";
      mode = [ "n" "v" ];
      options.desc = "Copy GitHub URL";
    }
  ];

  plugins = {
    fugitive = {
      enable = true;

      # Lazy load on git commands and keymaps
      lazyLoad.settings = {
        cmd = [
          "Git"
          "GBrowse"
        ];
        keys = [
          "<leader>gg"
          "<leader>gB"
          "<leader>go"
          "<leader>gy"
        ];
      };
    };
  };

  # vim-rhubarb provides :GBrowse GitHub integration for fugitive.
  # Loaded as a fugitive dependency via lz.n so both are available together.
  extraConfigLua = ''
    require("lz.n").load({
      {
        "vim-rhubarb",
        dep_of = { "vim-fugitive" },
      },
    })
  '';

  extraPlugins = with pkgs.vimPlugins; [ vim-rhubarb ];
}
