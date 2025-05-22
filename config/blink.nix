{ ... }:
{
  plugins = {
    blink-copilot = {
      enable = true;
    };


    # TODO: make it so first completion is accepted using tab
    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;

      settings = {
        appearance = {
          nerd_font_variant = "mono";
        };

        signature = {
          window = {
            border = "single";
          };
        };

        completion = {
          ghost_text = {
            enabled = true;
            show_with_menu = false;
          };

          menu = {
            border = "single";
            auto_show = false; # only show menu on <C-Space>
          };

          documentation = {
            window = {
              border = "single";
            };
          };

          accept = {
            auto_brackets = {
              enabled = true;

              semantic_token_resolution = {
                enabled = true;
              };
            };
          };

          documentation = {
            auto_show = true;
          };

          list = {
            selection = {
              preselect = true;
              auto_insert = true;
            };
          };
        };

        signature = {
          enabled = true;
        };

        sources = {
          default = [
            "lsp"
            "path"
            "buffer"
            "copilot"
          ];

          cmdline = [ ];

          providers = {
            buffer = {
              score_offset = -7;
            };

            lsp = {
              fallbacks = [ ];
            };

            copilot = {
              async = true;
              module = "blink-copilot";
              name = "copilot";
              score_offset = 100;
              opts = {
                max_completions = 3;
                max_attempts = 4;
                kind = "Copilot";
                debounce = 750;
                auto_refresh = {
                  backward = true;
                  forward = true;
                };
              };
            };
          };
        };

        keymap = {
          preset = "default";

          # if the completion menu is up, enter should select and accpt
          # otherwise enter should be a newline like default

          # the completion menu should be opened using <C-space>
          # "<enter>" = [
          #   "select_and_accept"
          # ];
        };
      };
    };
  };
}
