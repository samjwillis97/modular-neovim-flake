{ lib, config, pkgs, ... }:
with lib;
with builtins;
let
  enable = config.vim.ai.copilot.enableAll;
  cfg = config.vim.ai.copilot.chat;
in
{
  options.vim.ai.copilot.chat = {
    enable = mkOption {
      type = types.bool;
      default = enable;
      description = ''
        Enable Copilot chat.
      '';
    };

    prompts = mkOption {
      type = types.listOf (types.submodule ({...}: {
        options = {
          name = mkOption {
            type = types.str;
            description = "The name for the prompt. Has to be unique and PascalCase.";
          };

          prompt = mkOption {
            type = types.str;
            description = "The specific prompt.";
          };

          selection = mkOption {
            type = types.nullOr types.str; 
            default = null;
            description = "The selection function for the prompt.";
          };
        };
      }));
      default = [];
      description = "List of prompts.";
    };

  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [ "copilot-chat" ];
    vim.ai.copilot.completion.enable = true;
    vim.luaConfigRC.copilot-chat = nvim.dag.entryAnywhere ''
      ${optionalString (length cfg.prompts > 0) ''
      local select = require('CopilotChat.select')
      ''}

      local chat = require("CopilotChat").setup {
        ${optionalString (length cfg.prompts > 0) ''
          prompts = {
            ${concatStringsSep "\n" (map (prompt: ''
              ${prompt.name} = {
                prompt = "${prompt.prompt}",
                ${optionalString (prompt.selection != null) ''selection = ${prompt.selection},''}
              },
            '') cfg.prompts)}
          },
        ''} 
      }
    '';
  };
}
