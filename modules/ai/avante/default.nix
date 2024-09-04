{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.ai.avante;
in
{
  options.vim.ai.avante = {
    enable = mkEnableOption "avante";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [
      "avante"
      "nui"
      "plenary-nvim"
    ];
    vim.visuals.betterIcons = true;

    # TODO: some markdown plugin for chat
    vim.luaConfigRC.avante = nvim.dag.entryAnywhere ''
      require("avante").setup({
        provider = "copilot",
      })
    '';
  };
}
