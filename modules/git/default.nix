{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.git;
in
{
  options.vim.git = {
    enable = mkEnableOption "git";

    gutterSigns = mkOption {
      type = types.bool;
      default = true;
      description = "Enable git indicators in the column gutter";
    };

    gitInterface = mkOption {
      type = types.enum [
        "fugitive"
        "fugit2"
        "none"
      ];
      default = "fugitive";
      description = "Enable a git interface inside neovim";
    };

    prettyLog = mkEnableOption "Pretty log viewer";

    diffview = mkEnableOption "Better diff viewer";
  };

  config = mkIf (cfg.enable) (mkMerge [
    (mkIf (cfg.gitInterface == "fugit2") { vim.startPlugins = [ "fugit2" ]; })

    (mkIf (cfg.gitInterface == "fugitive") {
      vim.startPlugins = [
        "fugitive"
        "rhubarb"
      ];

      vim.nnoremap = {
        "<leader>gg" = ":Git<CR>";
        "<leader>gB" = ":Git blame<CR>";
      };
    })

    (mkIf (cfg.gutterSigns) {
      vim.startPlugins = [ "gitsigns" ];

      vim.luaConfigRC.gitsigns = nvim.dag.entryAnywhere ''
        require('gitsigns').setup()
      '';

      vim.vnoremap = {
        "<leader>gs" = ":Gitsigns stage_hunk<CR>";
        "<leader>gr" = ":Gitsigns reset_hunk<CR>";
      };

      vim.nnoremap = {
        "<leader>gs" = ":Gitsigns stage_hunk<CR>";
        "<leader>gu" = ":Gitsigns undo_stage_hunk<CR>";
        "<leader>gr" = ":Gitsigns reset_hunk<CR>";
        "<leader>gS" = ":Gitsigns stage_buffer<CR>";
        "<leader>gU" = ":Gitsigns reset_buffer_index<CR>";
        "<leader>gb" = ":lua require('gitsigns').blame_line{full=true}<CR>";
        "[g" = ":Gitsigns prev_hunk<CR>";
        "]g" = ":Gitsigns next_hunk<CR>";
      };
    })

    (mkIf cfg.prettyLog {
      vim.startPlugins = [
        "fugitive"
        "vim-flog"
      ];
    })

    (mkIf cfg.diffview {
      vim.startPlugins = [ "diffview" ];
      vim.luaConfigRC.diffview = nvim.dag.entryAnywhere ''
        require('diffview').setup({
          git_cmd = { "${pkgs.git}/bin/git" }
        })
      '';
    })
  ]);
}
