{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp.codeActionMenu = {
    enable = mkEnableOption "code action menu";
  };

  config = mkIf (cfg.enable && cfg.codeActionMenu.enable) {
    vim.startPlugins = [ "nvim-code-action-menu" ];

    vim.nnoremap = {
      "<leader>ca" = ":CodeActionMenu<CR>";
    };
  };
}
