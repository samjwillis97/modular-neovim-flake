{ pkgs, ... }:
let 
  # copilotModel = "gpt-4o-2024-11-20";
  copilotModel = "claude-3.7-sonnet";
in
{
  plugins.copilot-lua = {
    enable = true;
    nodePackage = pkgs.nodejs_20;
    settings = {
      copilot_model = copilotModel;

      suggestion = {
        enabled = false;
      };

      panel = {
        enabled = true;
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

  opts.laststatus = 3;

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
        model = copilotModel;
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
        enable_token_counting = true;
        auto_focus_sidebar = false;

        # Smart Tab
        # disabled because - https://github.com/yetone/avante.nvim/issues/1048
        auto_suggestions = false; # Experimental
        # auto_set_keymaps = true;
        # auto_apply_diff_after_generation = false;
        # support_paste_from_clipboard = false;
      };
    };
  };
}
