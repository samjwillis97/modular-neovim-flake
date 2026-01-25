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
    lazygit
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
    {
      key = "<leader>ff";
      action = "<CMD>lua Snacks.picker.files()<CR>";
      options.desc = "Open file search";
    }
    {
      key = "<leader>sf";
      action = "<CMD>lua Snacks.picker.git_grep()<CR>";
      options.desc = "Open grep over git files";
    }
    {
      key = "<leader>sw";
      action = "<CMD>lua Snacks.picker.grep_word()<CR>";
      options.desc = "Open grep for word under cursor";
    }
    {
      key = "gd";
      action = "<CMD>lua Snacks.picker.lsp_definitions()<CR>";
      options.desc = "Go to definition";
    }
    {
      key = "gr";
      action = "<CMD>lua Snacks.picker.lsp_references()<CR>";
      options.desc = "Find references";
    }
    {
      key = "gi";
      action = "<CMD>lua Snacks.picker.lsp_implementations()<CR>";
      options.desc = "Find implementations";
    }
  ];

  plugins.snacks = {
    enable = true;

    settings = {
      explorer = { };

      picker = {
        sources = {
          files = { };

          git_grep = { };

          grep_word = { };

          lsp_definitions = { };

          lsp_references = { };

          lsp_implementations = { };

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
