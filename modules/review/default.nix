{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.review;

  ghCliWithPAT = pkgs.writeShellScriptBin "ghCliWithPAT" ''
    GH_TOKEN=$(cat ${cfg.tokenPath})
    export GH_TOKEN

    ${pkgs.gh}/bin/gh "$@"
  '';
in
{
  options.vim.review = {
    enable = mkEnableOption "review";

    tokenPath = mkOption {
      description = "Path to a file containting github PAT, if not provided assumption is made that `gh` is on path and authenticated.";
      type =
        with types;
        nullOr (oneOf [
          path
          string
        ]);
      default = null;
    };
  };

  config = mkIf (cfg.enable) {
    vim.telescope.enable = true;
    vim.visuals = {
      enable = true;
      betterIcons = true;
    };

    vim.startPlugins = [ "octo" ];
    vim.luaConfigRC.octo = nvim.dag.entryAnywhere ''
      require("octo").setup({
        ${
          if (isNull cfg.tokenPath) then
            "gh_cmd = \"gh\""
          else
            "gh_cmd = \"${ghCliWithPAT}/bin/ghCliWithPAT\""
        }
      })
    '';
  };
}
