{
  description = "A very basic flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs"; };

    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      inherit (import ./lib/default.nix)
        mkNeovimConfiguration buildPkg neovimBin;
    in {

      ## TODO: what does this actually do?
      overlays.default = final: prev: {
        inherit mkNeovimConfiguration;
        neovim-base = buildPkg prev;
      };

      # // Updates the left attribute set with the right, { ...left, ...right } in JS kinda
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        neovim-base-pkg = buildPkg pkgs;
      in {
        packages = { neovim-base = neovimBin neovim-base-pkg; };

        apps = rec {
          neovim-base = {
            type = "app";
            program = neovimBin neovim-base-pkg;
          };
          default = neovim-base;
        };
      });
}
