{ lib, config, ... }:
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

    # TODO: Look at code actions with null_ls
  };

  config = mkIf cfg.enable {
    vim.startPlugins =
      (if (cfg.gitInterface != "none") then [ cfg.gitInterface ] else [ ])
      ++ (if (cfg.gutterSigns) then [ "gitsigns" ] else [ ]);

    vim.nnoremap =
      (
        if (cfg.gitInterface == "fugitive") then
          {
            "<leader>gg" = ":Git<CR>";
            "<leader>gB" = ":Git blame<CR>";
          }
        else
          { }
      )
      // (
        if (cfg.gutterSigns) then
          {
            "<leader>gp" = ":Gitsigns prev_hunk<CR>";
            "<leader>gn" = ":Gitsigns next_hunk<CR>";
            "<leader>gs" = ":Gitsigns stage_hunk<CR>";
            "<leader>gu" = ":Gitsigns undo_stage_hunk<CR>";
            "<leader>gr" = ":Gitsigns reset_hunk<CR>";
            "<leader>gS" = ":Gitsigns stage_buffer<CR>";
            "<leader>gU" = ":Gitsigns reset_buffer_index<CR>";
            "<leader>gb" = ":lua require('gitsigns').blame_line{full=true}<CR>";
          }
        else
          { }
      );

    vim.vnoremap =
      if (cfg.gutterSigns) then
        {
          "<leader>gs" = ":Gitsigns stage_hunk<CR>";
          "<leader>gr" = ":Gitsigns reset_hunk<CR>";
        }
      else
        { };

    vim.luaConfigRC.git = nvim.dag.entryAnywhere ''
      ${optionalString cfg.gutterSigns "require('gitsigns').setup()"};
    '';
  };
}
