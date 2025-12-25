{ system, nixpkgs, nixvim }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  baseModule = import ./config;

  # Helper to build nixvim with merged modules
  buildWithModules = modules:
    nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ baseModule ] ++ modules;
      };
      extraSpecialArgs = { inputs = { inherit nixpkgs nixvim; }; };
    };

  # Extend with a single inline module
  extend = module: buildWithModules [ module ];

  # Extend with a list of modules
  extendModules = modules: buildWithModules modules;
in
{
  inherit extend extendModules baseModule;
}
