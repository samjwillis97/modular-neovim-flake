{ pkgs, ... }:
{
  plugins.telescope = {
    enable = true;

    extensions = {
      live-grep-args.enable = true;
    };

    keymaps = {
      "<leader>ff" = {
        action = "git_files";
        options.desc = "Telescope Git files";
      };
      "<leader>sf" = {
        action = "live_grep";
        options.desc = "Telescope grep project";
      };
      "<leader>sw" = {
        action = "grep_string";
        options.desc = "Telescope grep word under cursor";
      };
      "<leader>sb" = {
        action = "current_buffer_fuzzy_find";
        options.desc = "Telescope in current buffer";
      };
      "<leader>fs" = {
        action = "treesitter";
        options.desc = "Telescope the treesitter graph";
      };

      "gd" = {
        action = "lsp_definitions";
        options.desc = "Go to definition";
      };
      "gr" = {
        action = "lsp_references";
        options.desc = "Find references";
      };
      "gi" = {
        action = "lsp_implementations";
        options.desc = "Find implementations";
      };
    };

    settings = {
      pickers = {
        find_command = "${pkgs.fd}/bin/fd";
      };
    };
  };
}
