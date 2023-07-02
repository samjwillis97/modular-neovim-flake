{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.statusline;
  evilLine = import ./evil.nix;
in {
  options.vim.statusline = {
    enable = mkEnableOption "statusline";

    style = mkOption {
      type = types.enum [ "evil" "default" ];
      default = "evil";
      description = "Style for the statusline";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = if (cfg.style == "evil") then [ "lualine" ] else [ ];
    vim.luaConfigRC.statusline = nvim.dag.entryAnywhere ''
      ${optionalString (cfg.style == "default") ''
        require('lualine').setup()
      ''}
      ${optionalString (cfg.style == "evil") evilLine.evil};
    '';
  };
}
