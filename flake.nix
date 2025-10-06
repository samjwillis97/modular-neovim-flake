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
    let
      config = import ./config;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        nixvimLib = nixvim.lib.${system};
        pkgs = import nixpkgs { inherit system; };
        nixvim' = nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
          };

          module = config;
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
        };

        devShells.default = import ./shell.nix { inherit pkgs; };

      }
    );
}
