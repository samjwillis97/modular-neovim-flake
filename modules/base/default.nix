{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim;
in {
  options.vim = {
    # TODO: Validate space binding
    leaderKey = mkOption {
      type = types.enum [ "space" "backslash" ];
      default = "backslash";
      description = "Key to bind to leader";
    };

    errorBell = mkOption {
      type = types.enum [ "visual" "sound" "both" "none" ];
      default = "none";
      description = "How to notify of errors messages";
    };

    lineNumberMode = mkOption {
      type = types.enum [ "relative" "number" "relNumber" "none" ];
      default = "relNumber";
      description =
        "How line numbers are displayed. none, relative, number, relNumber";
    };

    colourTerm = mkOption {
      type = types.bool;
      default = true;
      description = "Set terminal up for 256 colours";
    };

    showCursorLine = mkOption {
      type = types.bool;
      default = true;
      description = "Set to highlight the text line of the cursor";
    };

    signColumnMode = mkOption {
      type = types.enum [ "always" "never" "auto" ];
      default = "always";
      description = "How to display the sign column";
    };

    cmdHeight = mkOption {
      type = types.int;
      default = 1;
      description = "Height of the command bar";
    };

    scrollOffsetLines = mkOption {
      type = types.int;
      default = 8;
      description =
        "The minimum amount of lines to be above or below the cursor line";
    };

    enableSwapFile = mkOption {
      type = types.bool;
      default = false;
      description = "Creates swap files";
    };

    enableBackupFile = mkOption {
      type = types.bool;
      default = false;
      description = "Creates backup files";
    };

    undoFiles = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enables undo files to store history";
      };
      directory = mkOption {
        type = types.str;
        default = ''os.getenv("HOME") .. "/.vim/undodir/"'';
        description = "Location to store the undo files";
      };
    };

    tabs = {
      defaultWidth = mkOption {
        type = types.int;
        default = 2;
        description = "Default width of tabs";
      };

      expandToSpaces = mkOption {
        type = types.bool;
        default = true;
        description = "Expand tabs to be spaces";
      };
    };

    autoIndent = mkOption {
      type = types.bool;
      default = true;
      description =
        "Attempts to automatically indent correctly when starting new lines";
    };

    folding = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Wheter to enable folding";
      };

      defaultFoldNumber = mkOption {
        type = types.int;
        default = 5;
        description =
          "When opening a file it will close folds greater than this level";
      };

      maxNumber = mkOption {
        type = types.int;
        default = 10;
        description = ''Maximum nesting of folds for "indent" or "syntax"'';
      };

      mode = mkOption {
        type = types.enum [ "indent" "syntax" ];
        default = "indent";
        description = "The kind of folding to be used";
      };
    };

    syntaxHighlighting = mkOption {
      type = types.bool;
      default = true;
      description = "Enables syntax highlighting";
    };

    splitBelow = mkOption {
      type = types.bool;
      default = true;
      description = "New splits will open below instead of on top";
    };

    splitRight = mkOption {
      type = types.bool;
      default = true;
      description = "New splits will open on the right instead of left";
    };

    escapeWithJK = mkOption {
      type = types.bool;
      default = true;
      description = ''Bind "jk" to escape'';
    };

    centerAfterJump = mkOption {
      type = types.bool;
      default = true;
      description = "Center the cursor in the buffer after jumping";
    };

    moveByVisualLine = mkOption {
      type = types.bool;
      default = true;
      description = "Move by visual line rather than line number";
    };

    easierSplitNavigation = mkOption {
      type = types.bool;
      default = true;
      description = "Navigate between splits with <C-J> rather than <C-W><C-J>";
    };
  };

  config = {
    vim.startPlugins = [ "plenary-nvim" ];
    vim.inoremap = mkIf cfg.escapeWithJK { "jk" = "<Esc>"; };
    vim.nnoremap =
      (if (cfg.leaderKey == "space") then { "<space>" = "<nop>"; } else { })
      // (if (cfg.easierSplitNavigation) then {
        "<C-J>" = "<C-W><C-J>";
        "<C-K>" = "<C-W><C-K>";
        "<C-L>" = "<C-W><C-L>";
        "<C-H>" = "<C-W><C-H>";
      } else
        { }) // (if (cfg.centerAfterJump) then {
          "<C-u>" = "<C-u>zz";
          "<C-d>" = "<C-d>zz";
          "<C-i>" = "<C-i>zz";
          "<C-o>" = "<C-o>zz";
          "n" = "nzz";
          "N" = "Nzz";
          "GG" = "GGzz";
        } else
          { }) // (if (cfg.moveByVisualLine) then {
            "j" = "gj";
            "k" = "gk";
          } else
            { });
    vim.nmap = { "<leader><space>" = ":nohlsearch<CR>"; };

    vim.luaConfigRC.base = nvim.dag.entryAfter [ "globalsScript" ] ''
      -- Settings that are set for everything
      vim.opt.scrolloff = ${toString cfg.scrollOffsetLines}
      vim.opt.cmdheight = ${toString cfg.cmdHeight}
      vim.opt.tabstop = ${toString cfg.tabs.defaultWidth}
      vim.opt.softtabstop = ${toString cfg.tabs.defaultWidth}
      vim.opt.shiftwidth = ${toString cfg.tabs.defaultWidth}
      ${optionalString (cfg.tabs.expandToSpaces) ''
        vim.opt.expandtab = true
      ''}
      ${optionalString (cfg.autoIndent) ''
        vim.opt.smartindent = true
        vim.opt.autoindent = true
      ''}
      ${optionalString (cfg.leaderKey == "backslash") ''
        vim.g.mapleader = "\\"
      ''}
      ${optionalString (cfg.leaderKey == "space") ''
        vim.g.mapleader = "<space>"
      ''}
      ${optionalString (cfg.errorBell == "sound" || cfg.errorBell == "both") ''
        vim.opt.errorbells = true
      ''}
      ${optionalString (cfg.enableSwapFile) ''
        vim.opt.swapfile = true
        vim.opt.dir = "/tmp"
      ''}
      ${optionalString (!cfg.enableSwapFile) ''
        vim.opt.swapfile = false
      ''}
      ${optionalString (cfg.enableBackupFile) ''
        vim.opt.backup = true
      ''}
      ${optionalString (!cfg.enableBackupFile) ''
        vim.opt.backup = false
      ''}
      ${optionalString (cfg.undoFiles.enable) ''
        vim.opt.undofile = true
        vim.opt.undodir = ${cfg.undoFiles.directory}
      ''}
      ${optionalString
      (cfg.lineNumberMode == "number" || cfg.lineNumberMode == "relNumber") ''
        vim.opt.number = true
      ''}
      ${optionalString
      (cfg.lineNumberMode == "relative" || cfg.lineNumberMode == "relNumber") ''
        vim.opt.relativenumber = true
      ''}
      ${optionalString (cfg.showCursorLine) ''
        vim.opt.cursorline = true
      ''}
      ${optionalString (cfg.signColumnMode == "always") ''
        vim.opt.signcolumn = "yes"
      ''}
      ${optionalString (cfg.signColumnMode == "auto") ''
        vim.opt.signcolumn = "auto"
      ''}
      ${optionalString (cfg.errorBell == "visual" || cfg.errorBell == "both") ''
        vim.opt.visualbell = true
      ''}
      ${optionalString (cfg.colourTerm) ''
        vim.opt.termguicolors = true
      ''}
      ${optionalString (cfg.syntaxHighlighting) ''
        vim.opt.syntax = "on"
      ''}
      ${optionalString (cfg.folding.enable) ''
        vim.opt.foldenable = true
        vim.opt.foldlevelstart = ${toString cfg.folding.defaultFoldNumber}
        vim.opt.foldnestmax = ${toString cfg.folding.maxNumber}
        ${optionalString (!cfg.treesitter.enable || !cfg.treesitter.fold) ''
          vim.opt.foldmethod = "${cfg.folding.mode}"
        ''}
      ''}
      ${optionalString (cfg.splitBelow) ''
        vim.opt.splitbelow = true
      ''}
      ${optionalString (cfg.splitRight) ''
        vim.opt.splitright = true
      ''}
    '';
  };
}
