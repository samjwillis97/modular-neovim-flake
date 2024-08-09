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
    vim.startPlugins = [ "actions-preview" ];

    vim.luaConfigRC.code-actions = nvim.dag.entryAnywhere ''
      require("actions-preview").setup {}
    '';

    vim.nnoremap = {
      "<leader>ca" = ":lua require('actions-preview').code_actions()<CR>";
    };
  };
}
