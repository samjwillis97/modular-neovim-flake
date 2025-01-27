{
  keymaps = [
    {
      key = "<leader>n";
      action = "<CMD>Telescope noice<CR>";
    }
  ];

  plugins.noice = {
    enable = true;

    settings = {
      cmdline = {
          format = {
            cmdline = {
              pattern = "^:";
              icon = "";
              lang = "vim";
              opts = {
                border = {
                  text = {
                    top = "Cmd";
                  };
                };
              };
            };
            search_down = {
              kind = "search";
              pattern = "^/";
              icon = " ";
              lang = "regex";
            };
            search_up = {
              kind = "search";
              pattern = "^%?";
              icon = " ";
              lang = "regex";
            };
            filter = {
              pattern = "^:%s*!";
              icon = "";
              lang = "bash";
              opts = {
                border = {
                  text = {
                    top = "Bash";
                  };
                };
              };
            };
            lua = {
              pattern = "^:%s*lua%s+";
              icon = "";
              lang = "lua";
            };
            help = {
              pattern = "^:%s*he?l?p?%s+";
              icon = "󰋖";
            };
            input = { };
          };
        };

      messages = {
        view = "mini";
        view_error = "mini";
        view_warn = "mini";
      };

      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };

        progress.enabled = true;
        signature.enabled = true;
      };

      notify = {
        enable = true;
      };

      popupmenu.backend = "nui";

      presets = {
        bottom_search = false;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = true;
        lsp_doc_border = true;
      };

      views = {
        cmdline_popup = {
          border = {
            style = "single";
          };
        };

        confirm = {
          border = {
            style = "single";
            text = {
              top = "";
            };
          };
        };
      };
    };
  };
}
