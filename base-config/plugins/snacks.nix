let
  ToggleTreeKey = "<C-n>";
in
{
  keymaps = [
    {
      key = ToggleTreeKey;
      action = "<CMD>lua Snacks.explorer.open()<CR>";
      options.desc = "Toggle file explorer";
    }
  ];

  plugins.snacks = {
    enable = true;

    settings = {
      explorer = {

      };

      picker = {
        sources = {
          explorer = {
            layout = {
              preset = "select";
              preview = true;
            };
            win = {
              list = {
                keys = {
                  "<C-n>" = "cancel";
                };
              };
            };
          };
        };
      };
    };
  };
}
