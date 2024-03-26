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

    # I want a list of options that will be used to create prompts
    # each prompt starts with a question and alos has a selection function
    prompts = mkOption {
      type = types.listOf (types.submodule ({...}: {
        options = {
          name = mkOption {
            type = types.str;
            description = "The name for the prompt. Has to be unique and PascalCase.";
          };

          question = mkOption {
            type = types.str;
            description = "The question for the prompt.";
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
      local chat = require("CopilotChat").setup {
        ${optionalString (length cfg.prompts > 0) ''
          prompts = {
            ${concatStringsSep "\n" (map (prompt: ''
              ${prompt.name} = {
                prompt = "${prompt.question}",
                ${optionalString (prompt.selection != null) ''selection = ${prompt.selection},''}
              },
            '') cfg.prompts)}
          },
        ''} 
      }
    '';
  };
}
