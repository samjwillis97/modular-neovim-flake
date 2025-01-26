{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.filetree;
  gitEnabled = config.vim.git.enable;
  borderType = config.vim.visuals.borderType;

  locationMap = {
    "left" = "left";
    "right" = "right";
    "center" = "float";
  };
  location = locationMap.${cfg.location};
in
{
  options.vim.filetree = {
    enable = mkEnableOption "filetree";

    location = mkOption {
      type = types.enum [
        "left"
        "right"
        "center"
      ];
      default = "left";
      description = "Where the tree will appear";
    };

    width = mkOption {
      type = types.int;
      default = 35;
      description = ''Width of the file tree in columns when location is "left" or "right", and the ratio to full screen when "center"'';
    };

    filters = {
      custom = mkOption {
        type = with types; listOf str;
        default = [
          ".git"
          "node_modules"
          ".devenv"
          ".direnv"
        ];
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

    followCurrentFile = mkOption {
      type = types.bool;
      default = true;
      description = "Follow the current file";
    };
  };

  config = mkIf cfg.enable {
    vim.visuals.betterIcons = true;

    vim.startPlugins = [
      "neotree"
      "nui"
      "window-picker"
    ];

    vim.nnoremap = {
      "<C-n>" = ":Neotree toggle<CR>";
      ",n" = ":Neotree reveal<CR>";
    };

    vim.luaConfigRC.filetree = nvim.dag.entryAnywhere ''
      require("neo-tree").setup({
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "document_symbols",
        },
        -- source_selector = {
        --   { source = "filesystem" },
        --   { source = "buffers" },
        --   { source = "git_status" },
        --   { source = "document_symbols" },
        -- },
        close_if_last_window = ${lib.trivial.boolToString cfg.autoCloseOnLastWindow},
        enable_diagnostics = true,
        window = {
          position = "${location}",
          ${optionalString (cfg.location != "center") ''width = ${toString cfg.width},''}
          popup = {
            size = {
              ${optionalString (cfg.location == "center") ''width = "${toString cfg.width}%",''}
            },
          },
          mappings = {
            ["o"] = "open_with_window_picker",
            ["oc"] = "none",
            ["od"] = "none",
            ["og"] = "none",
            ["om"] = "none",
            ["on"] = "none",
            ["os"] = "none",
            ["ot"] = "none",
            ["O"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "O" } },
            ["Oc"] = "order_by_created",
            ["Od"] = "order_by_diagnostics",
            ["Og"] = "order_by_git_status",
            ["Om"] = "order_by_modified",
            ["On"] = "order_by_name",
            ["Os"] = "order_by_size",
            ["Ot"] = "order_by_type",
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = ${lib.trivial.boolToString cfg.followCurrentFile},
          },
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = ${lib.trivial.boolToString cfg.filters.dotFiles},
            hide_gitignored = ${lib.trivial.boolToString cfg.filters.gitIgnore},
            hide_by_pattern = {
              ${builtins.concatStringsSep "\n" (builtins.map (v: "\"${v}\",") cfg.filters.custom)}
            },
          },
          group_empty_dirs = ${lib.trivial.boolToString cfg.groupEmptyDirectories},
        },
        default_component_configs = {
          name = {
            trailing_slash = ${lib.trivial.boolToString cfg.addTrailingSlash},
          },
        },
        ${optionalString (borderType != null) ''popup_border_style = "${borderType}",''}
        ${optionalString gitEnabled ''enable_git_status = true,''}
      })

      ${optionalString (cfg.openOnLaunch) ''
        vim.api.nvim_create_autocmd({ "VimEnter" }, { 
          callback = function vim.cmd([[:Neotree focus]]) end,
        })
      ''}
    '';
  };
}
