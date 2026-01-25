{ pkgs, ... }:
let
  ToggleTreeKey = "<C-n>";

  configurableSelectLayout =
    {
      width ? 0.5,
      height ? 0.4,
    }:
    {
      hidden = [ "preview" ];
      layout = {
        inherit height width;
        backdrop = false;
        min_width = 80;
        max_width = 100;
        min_height = 2;
        box = "vertical";
        border = true;
        title = "{title}";
        title_pos = "center";
        __unkeyed-1 = {
          win = "input";
          height = 1;
          border = "bottom";
        };
        __unkeyed-2 = {
          win = "list";
          border = "none";
        };
        __unkeyed-3 = {
          win = "preview";
          title = "{preview}";
          height = 0.4;
          border = "top";
        };
      };
    };
in
{
  extraPackages = with pkgs; [
    fd
    ripgrep
  ];

  keymaps = [
    {
      key = ToggleTreeKey;
      action = "<CMD>lua Snacks.explorer.open()<CR>";
      options.desc = "Toggle file explorer";
    }
    {
      key = ",n";
      action = "<CMD>lua Snacks.explorer.open()<CR>";
      options.desc = "Toggle file explorer";
    }
  ];

  plugins.snacks = {
    enable = true;

    settings = {
      explorer = { };

      picker = {
        sources = {
          explorer = {
            auto_close = true;
            layout = configurableSelectLayout ({
              height = 0.8;
              width = 0.35;
            });
            win = {
              list = {
                keys = {
                  "<C-n>" = "cancel";
                  "h" = "explorer_close";
                  "o" = "confirm";
                  "O" = "explorer_open";
                };
              };
            };
          };
        };
      };
    };
  };
}
