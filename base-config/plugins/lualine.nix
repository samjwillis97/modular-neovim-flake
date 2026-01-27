let
  colors = {
    fg = "#bbc2cf";
    bg = "#202328";
    white = "#ffffff";
    red = "#ec5f67";
    green = "#98be65";
    blue = "#51afef";
    magenta = "#c678dd";
    orange = "#FF8800";
    yellow = "#ECBE7B";
    violet = "#a9a1e1";
    cyan = "#008080";
  };
in
{
  plugins.lualine = {
    enable = true;

    # Load after startup for statusline
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };

    settings = {
      options = {
        # Disable sections and component separators
        component_separators = "";
        section_separators = "";
        theme = {
          # Custom theme based on evil_lualine
          normal = {
            c = {
              fg = colors.fg;
              bg = colors.bg;
            };
          };
          inactive = {
            c = {
              fg = colors.fg;
              bg = colors.bg;
            };
          };
        };
      };

      sections = {
        # Clear default sections - override with empty raw lua
        lualine_a = {
          __raw = "{}";
        };
        lualine_b = {
          __raw = "{}";
        };
        lualine_y = {
          __raw = "{}";
        };
        lualine_z = {
          __raw = "{}";
        };

        # Left section components
        lualine_c = [
          # Left bar indicator
          {
            __unkeyed-1.__raw = ''
              function()
                return '▊'
              end
            '';
            color = {
              fg = colors.blue;
            };
            padding = {
              left = 0;
              right = 1;
            };
          }

          # Mode indicator
          {
            __unkeyed-1.__raw = ''
              function()
                return ''
              end
            '';
            color = {
              __raw = ''
                function()
                  local mode_color = {
                    n = "${colors.red}",
                    i = "${colors.green}",
                    v = "${colors.blue}",
                    ['''] = "${colors.blue}",
                    V = "${colors.blue}",
                    c = "${colors.magenta}",
                    no = "${colors.red}",
                    s = "${colors.orange}",
                    S = "${colors.orange}",
                    ['''] = "${colors.orange}",
                    ic = "${colors.yellow}",
                    R = "${colors.violet}",
                    Rv = "${colors.violet}",
                    cv = "${colors.red}",
                    ce = "${colors.red}",
                    r = "${colors.cyan}",
                    rm = "${colors.cyan}",
                    ['r?'] = "${colors.cyan}",
                    ['!'] = "${colors.red}",
                    t = "${colors.red}",
                  }
                  return { fg = mode_color[vim.fn.mode()] }
                end
              '';
            };
            padding = {
              right = 1;
            };
          }

          # Filesize
          {
            __unkeyed-1 = "filesize";
            cond.__raw = ''
              function()
                return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
              end
            '';
            color = {
              fg = colors.fg;
            };
          }

          # Filename
          {
            __unkeyed-1 = "filename";
            cond.__raw = ''
              function()
                return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
              end
            '';
            color = {
              fg = colors.magenta;
              gui = "bold";
            };
          }

          # Location
          {
            __unkeyed-1 = "location";
            color = {
              fg = colors.fg;
            };
          }

          # Progress
          {
            __unkeyed-1 = "progress";
            color = {
              fg = colors.fg;
            };
          }

          # Diagnostics
          {
            __unkeyed-1 = "diagnostics";
            sources = [ "nvim_diagnostic" ];
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
            };
            diagnostics_color = {
              error = {
                fg = colors.red;
              };
              warn = {
                fg = colors.yellow;
              };
              info = {
                fg = colors.cyan;
              };
            };
          }

          # Mid section separator
          {
            __unkeyed-1.__raw = ''
              function()
                return '%='
              end
            '';
          }

          # LSP server name
          {
            __unkeyed-1.__raw = ''
              function()
                local msg = 'No Active Lsp'
                local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
                local clients = vim.lsp.get_clients()
                if next(clients) == nil then
                  return msg
                end
                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                  end
                end
                return msg
              end
            '';
            icon = " LSP:";
            color = {
              fg = colors.white;
              gui = "bold";
            };
          }
        ];

        # Right section components
        lualine_x = [
          # Encoding
          {
            __unkeyed-1 = "o:encoding";
            fmt.__raw = "string.upper";
            cond.__raw = ''
              function()
                return vim.fn.winwidth(0) > 90
              end
            '';
            color = {
              fg = colors.green;
              gui = "bold";
            };
          }

          # File format
          {
            __unkeyed-1 = "fileformat";
            fmt.__raw = "string.upper";
            icons_enabled = false;
            color = {
              fg = colors.green;
              gui = "bold";
            };
          }

          # Branch
          {
            __unkeyed-1 = "branch";
            icon = "";
            color = {
              fg = colors.violet;
              gui = "bold";
            };
          }

          # Diff
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = "󰝤 ";
              removed = " ";
            };
            diff_color = {
              added = {
                fg = colors.green;
              };
              modified = {
                fg = colors.orange;
              };
              removed = {
                fg = colors.red;
              };
            };
            cond.__raw = ''
              function()
                return vim.fn.winwidth(0) > 90
              end
            '';
          }

          # Right bar indicator
          {
            __unkeyed-1.__raw = ''
              function()
                return '▊'
              end
            '';
            color = {
              fg = colors.blue;
            };
            padding = {
              left = 1;
            };
          }
        ];
      };

      inactive_sections = {
        lualine_a = {
          __raw = "{}";
        };
        lualine_b = {
          __raw = "{}";
        };
        lualine_y = {
          __raw = "{}";
        };
        lualine_z = {
          __raw = "{}";
        };
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            cond.__raw = ''
              function()
                return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
              end
            '';
            color = {
              fg = colors.fg;
              gui = "bold";
            };
          }
        ];
        lualine_x = {
          __raw = "{}";
        };
      };
    };
  };
}
