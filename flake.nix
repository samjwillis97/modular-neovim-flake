{
  description = "Sam's Neovim Flake 🤭";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixvim,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        nixvimLib = nixvim.lib.${system};
        pkgs = import nixpkgs { inherit system; };
        nixvim' = nixvim.legacyPackages.${system};

        # Use full-config as the default build
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
          };

          module = import ./full-config;
        };

        nvim-light = nixvim'.makeNixvimWithModule {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
          };

          module = import ./base-config;
        };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        checks = {
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "My nixvim configuration";
          };
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
          light = nvim-light;
        };

        devShells.default = import ./shell.nix { inherit pkgs; };

        # Extension library for composing with project-specific configs
        lib = import ./lib.nix {
          inherit system nixpkgs nixvim;
        };
      }
    );
}
