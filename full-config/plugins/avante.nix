{ pkgs, ... }:
let
  # copilotModel = "gpt-4o-2024-11-20";
  copilotModel = "claude-4.5-sonnet";
in
{
  plugins.copilot-lua = {
    enable = true;

    # Load on VeryLazy for copilot support
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };

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

  opts.laststatus = 3;

  plugins.avante = {
    enable = true;

    # Load on VeryLazy for AI assistant
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };

    settings = {
      # The following are the default values
      provider = "copilot";
      # auto_suggestions_provider = "copilot";
      # cursor_applying_provider = "copilot";
      # memory_summary_provider = "copilot";

      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com";
          model = copilotModel;
          proxy = null;
          allow_insecure = false;
          timeout = 30000;
          extra_request_body = {
            temperature = 0;
            max_tokens = 175000;
          };
        };
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
