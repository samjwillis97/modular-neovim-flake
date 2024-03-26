{ lib, ... }:
with lib;
with builtins;
{
  imports = [
    ./chat.nix
    ./completion.nix
  ];

  options.vim.ai.copilot = {
    enableAll = mkEnableOption "copilot";
  };
}
