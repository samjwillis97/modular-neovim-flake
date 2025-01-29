{
  plugins.copilot-lua = {
    enable = true;
  };

  plugins.render-markdown = {
    enable = true;

    settings = {
      file_types = [ "markdown" "Avante" ];

      code = {
        above = "▄";
        below = "▀";
        style = "normal";
      };
    };
  };

  plugins.avante = {
    enable = true;

    settings = {
      provider = "copilot";
      auto_suggestions_frequency = "copilot";

      hints = {
        enabled = true;
      };

      behaviour = {
        auto_suggestions = false;
      };
    };
  };
}
