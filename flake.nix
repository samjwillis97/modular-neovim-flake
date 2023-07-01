{
  description = "A very basic flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs"; };

    flake-utils = { url = "github:numtide/flake-utils"; };

    # Plugins
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      nvimLib = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib).nvim;

      availablePlugins = [ "nvim-tree-lua" ];
      rawPlugins = nvimLib.plugins.inputsToRaw inputs availablePlugins;

      inherit (import ./lib/default.nix { inherit rawPlugins; })
        mkNeovimConfiguration buildPkg;

      baseConfig = { config = { vim.filetree.enable = true; }; };
    in {

      # // Updates the left attribute set with the right, { ...left, ...right } in JS kinda
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (prev: final: {
            inherit mkNeovimConfiguration;
            neovim-base = buildPkg final [ baseConfig ];
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in {
        packages = rec {
          neovim-base = pkgs.neovim-base;
          default = neovim-base;
        };

        apps = rec {
          neovim-base = flake-utils.lib.mkApp {
            drv = self.packages.${system}.neovim-base;
            exePath = "/bin/nvim";
          };
          default = neovim-base;
        };
      });
}
