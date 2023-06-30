{
  description = "A very basic flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs"; };

    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      inherit (import ./lib/default.nix { })
        mkNeovimConfiguration buildPkg neovimBin;

    in {
      ## TODO: what does this actually do?
      overlays.default = final: prev: {
        inherit mkNeovimConfiguration;
        neovim-all = buildPkg prev;
      };

      # // Updates the left attribute set with the right, { ...left, ...right } in JS kinda
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        defaultPkg = buildPkg pkgs;
      in {
        packages = { defaultNvim = neovimBin defaultPkg; };

        apps = rec {
          defaultNvim = {
            type = "app";
            program = neovimBin defaultPkg;
          };
          default = defaultNvim;
        };
      });
}
