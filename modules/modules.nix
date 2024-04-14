{
  pkgs,
  lib,
  check ? true,
}:
let
  modules = [
    ./base
    ./filetree
    ./treesitter
    ./telescope
    ./git
    ./statusline
    ./languages
    ./theme
    ./visuals
    ./qol
    ./lsp
    ./formatter
    ./snippets
    ./completion
    ./ai
    ./debugger
    ./review
    ./core
    ./build
  ];

  # TODO: What does this module do?
  pkgsModule =
    { config, ... }:
    {
      config = {
        _module.args.baseModules = modules;
        _module.args.pkgsPath = lib.mkDefault pkgs.path;
        _module.args.pkgs = lib.mkDefault pkgs;
        _module.check = check; # TODO: What does check do?
      };
    };
in
modules ++ [ pkgsModule ]
