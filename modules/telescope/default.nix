{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.telescope;
in
{
  options.vim.telescope = {
    enable = mkEnableOption "telescope";

    frecency = {
      enable = mkEnableOption "frecency";
    };

    undo = {
      enable = mkEnableOption "undo";
    };
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins =
      [ "telescope" ]
      ++ (if cfg.frecency.enable then [ "telescope-frecency" ] else [ ])
      ++ (if cfg.undo.enable then [ "telescope-undo" ] else [ ]);

    vim.nnoremap =
      {
        "<leader>ff" = ":Telescope git_files<CR>";
        "<leader>fb" = ":Telescope buffers<CR>";
        "<leader>sf" = ":Telescope live_grep<CR>";
        "<leader>sw" = ":Telescope grep_string<CR>";
        "<leader>sb" = ":Telescope current_buffer_fuzzy_find<CR>";
      }
      // (if cfg.frecency.enable then { "<leader>fF" = ":Telescope frecency<CR>"; } else { })
      // (if config.vim.treesitter.enable then { "<leader>fs" = ":Telescope treesitter<CR>"; } else { })
      // (
        if config.vim.lsp.enable then
          {
            "gd" = ":Telescope lsp_definitions<CR>";
            "gr" = ":Telescope lsp_references<CR>";
            "gi" = ":Telescope lsp_implementations<CR>";
          }
        else
          { }
      );

    # TODO: Evaluate these defaults
    vim.luaConfigRC.telescope = nvim.dag.entryAnywhere ''
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "${pkgs.ripgrep}/bin/rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          pickers = {
            find_command = {
              "${pkgs.fd}/bin/fd",
            },
          },
        }
      })

      ${optionalString cfg.frecency.enable ''
        require("telescope").load_extension "frecency"

        require("frecency.config").setup {
          default_workspace = "CWD",
          matcher = "fuzzy",
          hide_current_buffer = true,
          show_filter_column = false,
        }
      ''}

      ${optionalString cfg.undo.enable ''
        require("telescope").load_extension "undo"
      ''}
    '';
  };
}
