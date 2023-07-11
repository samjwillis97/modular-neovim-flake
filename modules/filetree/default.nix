{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.filetree;
  visualCfg = config.vim.visuals;
in
{
  options.vim.filetree = {
    enable = mkEnableOption "filetree";

    location = mkOption {
      type = types.enum [ "left" "right" "center" ];
      default = "left";
      description = "Where the tree will appear";
    };

    width = mkOption {
      type = types.int;
      default = 35;
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

    openOnLaunch = mkOption {
      type = types.bool;
      default = false;
      description = "Open file tree on launch";
    };

    addTrailingSlash = mkOption {
      type = types.bool;
      default = true;
      description = "Add a trailing slash to directories";
    };

    groupEmptyDirectories = mkOption {
      type = types.bool;
      default = false;
      description = "Groups empty directories";
    };

    autoCloseOnLastWindow = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically closes tree if it is the last window left";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ "nvim-tree-lua" ];

    vim.nnoremap = {
      "<C-n>" = ":NvimTreeToggle<CR>";
      ",n" = ":NvimTreeFindFile<CR>";
    };

    vim.luaConfigRC.filetree = nvim.dag.entryAnywhere ''
      ${optionalString (cfg.openOnLaunch) ''
        local function open_nvim_tree()
          require("nvim-tree.api").tree.open()
        end

        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
      ''}

      ${optionalString (cfg.autoCloseOnLastWindow) ''
        vim.api.nvim_create_autocmd({"QuitPre"}, {
          callback = function() vim.cmd("NvimTreeClose") end,
        })
      ''}
        
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
                            ${optionalString (!visualCfg.enable) ''border = "none",''}
                            ${optionalString (visualCfg.enable && visualCfg.borderType == "rounded") ''border = "rounded",''}
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
                side = "${cfg.location}",
              ''
            }
          },
          renderer = {
              add_trailing = ${boolToString cfg.addTrailingSlash},
              group_empty = ${boolToString cfg.groupEmptyDirectories},
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
          filesystem_watchers = {
            enable = true,
          },
      })
    '';
  };
}
