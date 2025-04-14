{ pkgs, ... }:
{
  plugins.copilot-lua = {
    enable = true;
    nodePackage = pkgs.nodejs_20;
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
        auto_focus_sidebar = false;
      };
    };
  };
}
