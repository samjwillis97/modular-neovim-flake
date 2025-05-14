{ pkgs, ... }:
{
  plugins.copilot-lua = {
    enable = true;
    nodePackage = pkgs.nodejs_20;
    settings = {
      copilot_model = "claude-3.7-sonnet";

      suggestion = {
        enabled = true;
        auto_trigger = true;
        hide_during_completion = true;
        trigger_on_accept = true;
      };
    };
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
      # The following are the default values
      provider = "copilot";
      # auto_suggestions_provider = "copilot";
      # cursor_applying_provider = "copilot";
      # memory_summary_provider = "copilot";

      copilot = {
        endpoint = "https://api.githubcopilot.com";
        # model = "gpt-4o-2024-11-20";
        model = "claude-3.7-sonnet";
        proxy = null;
        allow_insecure = false;
        timeout = 30000;
        temperature = 0;
        max_tokens = 175000;
      };

      hints = {
        enabled = true;
      };

      behaviour = {
        auto_focus_sidebar = false;
        auto_suggestions = false; # Experimental
        enable_token_counting = true;
      };
    };
  };
}
