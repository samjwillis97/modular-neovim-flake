# Gleam-specific neovim configuration
#
# This module configures LSP, syntax highlighting, and formatting for Gleam

{ pkgs, ... }:
{
  # Enable Gleam LSP
  plugins.lsp.servers.gleam = {
    enable = true;
    package = pkgs.gleam;
  };

  # Add Gleam syntax highlighting and support
  extraPlugins = with pkgs.vimPlugins; [
    # Note: Gleam has built-in treesitter support in newer versions
    # If you need additional plugins, add them here
  ];

  # Configure formatting for Gleam files
  plugins.conform-nvim.settings.formatters_by_ft.gleam = [ "gleam" ];

  # Add Gleam-specific settings
  extraConfigLua = ''
    -- Gleam-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "gleam",
      callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
      end,
    })
  '';
}
