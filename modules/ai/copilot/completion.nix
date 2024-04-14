{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with builtins;
let
  enable = config.vim.ai.copilot.enableAll;
  cfg = config.vim.ai.copilot.completion;
in
{
  options.vim.ai.copilot.completion = {
    enable = mkOption {
      type = types.bool;
      default = enable;
      description = ''
        Enable Copilot completion.
      '';
    };

    nodeCommand = mkOption {
      type = types.str;
      default = "${pkgs.nodejs_20}/bin/node";
      description = ''
        The path to the node command to use for running Copilot.
      '';
    };

    workspaceFolders = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        A list of paths to workspace folders that Copilot should use to improve quality
      '';
    };
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [ "copilot" ];

    vim.luaConfigRC.copilot = nvim.dag.entryAnywhere ''
      vim.g.copilot_node_command = "${cfg.nodeCommand}"
      vim.g.copilot_workspace_folders = {${
        lib.concatStrings (map (v: "\n\"${v}\",") cfg.workspaceFolders)
      }
      }
    '';
  };
}
