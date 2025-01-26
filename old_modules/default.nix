{
  modules ? [ ],
  pkgs,
  lib ? pkgs.lib,
  check ? true,
  extraSpecialArgs ? { },
}:
# TODO: Have a look at extended lib from jordanisaacs 
let
  extendedLib = import ./lib/stdlib-extended.nix lib;

  nvimModules = import ./modules.nix {
    inherit check pkgs;
    lib = extendedLib;
  };

  module = extendedLib.evalModules {
    modules = modules ++ nvimModules;
    specialArgs = {
      modulesPath = builtins.toString ./.;
      currentModules = modules;
    } // extraSpecialArgs;
  };
in
module.config.built.package
