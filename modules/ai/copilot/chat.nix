{ lib, config, pkgs, ... }:
with lib;
with builtins;
let
  enable = config.vim.ai.copilot.enableAll;
  cfg = config.vim.ai.copilot.chat;
in
{
  options.vim.ai.copilot.chat= {
    enable = mkOption {
      type = types.bool;
      default = enable;
      description = ''
        Enable Copilot chat.
      '';
    };
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [ "copilot-chat" ];
    vim.ai.copilot.completion.enable = true;
    vim.luaConfigRC.copilot-chat = nvim.dag.entryAnywhere ''
      local chat = require("CopilotChat").setup {}
    '';
  };
}
