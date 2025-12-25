# Gleam Project Example
#
# This shows how to extend the base neovim config for a Gleam project
# using separate module files for better organization.

{
  description = "Gleam project with extended neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-neovim.url = "path:../../";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      my-neovim,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = [
            # Extend base neovim with Gleam-specific configuration
            (my-neovim.lib.${system}.extendModules [
              ./neovim/gleam.nix
              ./neovim/keymaps.nix
            ])

            # Gleam tooling
            pkgs.gleam
            pkgs.erlang
            pkgs.rebar3
          ];

          shellHook = ''
            echo "Gleam development environment loaded!"
            echo "Neovim configured with:"
            echo "  - Gleam LSP"
            echo "  - Syntax highlighting"
            echo "  - Custom keymaps for testing and building"
          '';
        };

        # You can also create multiple dev shells with different configs
        minimal = pkgs.mkShell {
          packages = [
            # Use base neovim without extensions
            my-neovim.packages.${system}.default
            pkgs.gleam
          ];
        };
      };
    };
}
