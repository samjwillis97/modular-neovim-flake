{ pkgs, config, lib, ... }:
with lib;
with builtins;
let cfg = config.vim.telescope;
in {
  options.vim.telescope = { enable = mkEnableOption "telescope"; };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [ "telescope" ];

    vim.nnoremap = {
      "<leader>ff" = ":Telescope git_files<CR>";
      "<leader>fb" = ":Telescope buffers<CR>";
      "<leader>gf" = ":Telescope live_grep<CR>";
      "<leader>gw" = ":Telescope live_grep<CR>";
      "<leader>gb" = ":Telescope current_buffer_fuzzy_find<CR>";
    } // (if config.vim.treesitter.enable then {
      "<leader>fs" = ":Telescope treesitter<CR>";
    } else
      { });
    # TODO: Come back to this
    # // (if config.vim.lsp.enable then {
    #   "gd" = ":Telescope lsp_definitions<CR>";
    #   "gr" = ":Telescope lsp_references<CR>";
    #   "gi" = ":Telescope lsp_implementations<CR>";
    # } else
    #   { });

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
    '';
  };
}
