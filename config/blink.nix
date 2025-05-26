{ lib, ... }:
let 
  border = false;
in
{
  plugins = {
    blink-copilot = {
      enable = true;
    };

    colorful-menu = {
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
            border = if border then "single" else null;
          };
        };

        completion = {
          ghost_text = {
            enabled = true;
            show_with_menu = false;
          };

          menu = {
            enabled = true;
            border = if border then "single" else null;
            auto_show = false; # only show menu on <C-Space>

            # Supporting colorful menu
            draw = {
              # This is a really annoying datastructure to define in Nix
              columns = lib.nixvim.utils.mkRaw ''
                { { "kind_icon" }, { "label", gap = 1 } }
              '';
              components = {
                label = {
                  text = lib.nixvim.utils.mkRaw ''
                      require("colorful-menu").blink_components_text
                  '';
                  highlight = lib.nixvim.utils.mkRaw ''
                      require("colorful-menu").blink_components_highlight
                  '';
                };
              };
            };
          };

          documentation = {
            window = {
              border = if border then "single" else null;
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

          # if the completion menu is up, enter should select and accept
          # otherwise enter should be a newline like default
          "<Enter>" = let
              function = lib.nixvim.utils.mkRaw ''
                function(cmp)
                  if cmp.is_menu_visible() then 
                    return cmp.accept()
                  end
                end
              '';
            in
            [
              function
              "fallback"
            ];

          # "<C-space>" = [
          #   "show"
          #   "fallback"
          # ];

          "<C-d>" = [ "scroll_documentation_up" "fallback" ];
          "<C-f>" = [ "scroll_documentation_down" "fallback" ];

          # This handles "Tab" accepting the ghost text
          "<Tab>" = [ "select_and_accept" "fallback" ];
        };
      };
    };
  };
}
