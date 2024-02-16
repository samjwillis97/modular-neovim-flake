{ lib, config, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.vim.review;

  ghCliWithPAT = pkgs.writeShellApplication {
    name = "ghCliWithPAT";
    runtimeInputs = [ pkgs.gh ];
    text = ''
      GH_TOKEN=$(${pkgs.age}/bin/age -d -i /var/agenix/github-primary ${../../secrets/gh_pat.age})
      export GH_TOKEN

      ${pkgs.gh}/bin/gh "$@"
    '';
  };
in
{
  options.vim.review = {
    enable = mkEnableOption "review";
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
        gh_cmd = "${ghCliWithPAT}/bin/ghCliWithPAT",
      })
    '';
  };
}
