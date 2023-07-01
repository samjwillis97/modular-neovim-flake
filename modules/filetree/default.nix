{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.filetree;
in {
  options.vim.filetree = {
    enable = mkEnableOption "filetree";

    location = mkOption {
      type = types.enum [ "left" "right" "center" ];
      default = "left";
      description = "Where the tree will appear";
    };

    width = mkOption {
      type = types.int;
      default = 30;
      description = ''
        Width of the file tree in columns when location is "left" or "right", and the ratio to full screen when "center"'';
    };

    filters = {
      custom = mkOption {
        type = with types; listOf str;
        default = [ ".git" "node_modules" ".devenv" ];
        description = "Files and directories to hide in the tree by default";
      };
      gitIgnore = mkOption {
        type = types.bool;
        default = false;
        description = "Hide files and directories ignored in .gitignore file";
      };
      dotFiles = mkOption {
        type = types.bool;
        default = false;
        description = "Hide files and directories starting with '.'";
      };
    };

    #FIXME:
    # - Location right
    # - Open on Launch
    # - Close on Last Window
    # - Close on File Opened
    # - Follow currently open file
    # - Add trailing slash to directories
    # - Command to open Files
    # - Filesystem watcher?
    # - Renderer group empty?

    # TODO: Look at netrw stuff
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ "nvim-tree-lua" ];

    vim.nnoremap = {
      "<C-n>" = ":NvimTreeToggle<CR>";
      ",n" = ":NvimTreeFindFile<CR>";
    };

    vim.luaConfigRC.filetree = nvim.dag.entryAnywhere ''
      require("nvim-tree").setup({
          view = {
            ${
              optionalString (cfg.location == "center") ''
                float = {
                    enable = true,
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                        local window_w = screen_w * ${
                          toString ((cfg.width + 0.0) / 100)
                        }
                        local window_h = screen_h * 0.75 
                        local window_w_int = math.floor(window_w)
                        local window_h_int = math.floor(window_h)
                        local center_x = (screen_w - window_w) / 2
                        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                        return {
                            border = "none",
                            relative = "editor",
                            row = center_y,
                            col = center_x,
                            width = window_w_int,
                            height = window_h_int,
                        }
                    end,
                },
                width = function()
                    return math.floor(vim.opt.columns:get() * ${
                      toString ((cfg.width + 0.0) / 100)
                    })
                end,
              ''
            }
            ${
              optionalString (cfg.location != "center") ''
                width = ${toString cfg.width},
              ''
            }
          },
          git = {
              enable = true,
              ignore = ${boolToString cfg.filters.gitIgnore},
          },
          filters = {
              dotfiles = ${boolToString cfg.filters.dotFiles},
              custom = {
                  ${
                    builtins.concatStringsSep "\n"
                    (builtins.map (s: ''"'' + s + ''",'') cfg.filters.custom)
                  }
              },
          },
      })
    '';
  };
}
