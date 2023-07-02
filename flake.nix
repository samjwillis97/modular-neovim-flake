{
  description = "Sam's Modular Neovim Flake 🤭";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs"; };
    flake-utils = { url = "github:numtide/flake-utils"; };

    # Plugins
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    fugitive = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    # Themes
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    onedark = {
      url = "github:navarasu/onedark.nvim";
      flake = false;
    };
    catppuccin = {
      url = "github:catppuccin/nvim";
      flake = false;
    };
    dracula-nvim = {
      url = "github:Mofiqul/dracula.nvim";
      flake = false;
    };
    dracula = {
      url = "github:dracula/vim";
      flake = false;
    };
    gruvbox = {
      url = "github:ellisonleao/gruvbox.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      nvimLib = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib).nvim;

      availablePlugins = [
        "plenary-nvim"
        "nvim-tree-lua"
        "telescope"
        "fugitive"
        "gitsigns"
        "tokyonight"
        "onedark"
        "catppuccin"
        "dracula-nvim"
        "dracula"
        "gruvbox"
      ];
      rawPlugins = nvimLib.plugins.inputsToRaw inputs availablePlugins;

      inherit (import ./lib/default.nix { inherit rawPlugins; })
        mkNeovimConfiguration buildPkg;

      baseConfig = {
        config = {
          vim = {
            theme = {
              enable = true;
              name = "catppuccin";
            };
            git.enable = true;
            filetree = {
              enable = true;
              location = "left";
              width = 30;
            };
            treesitter = {
              enable = true;
              fold = true;
            };
            telescope.enable = true;
            languages = {
              enableTreesitter = true;
              nix.enable = true;
              nix.treesitter.enable = true;
            };
          };
        };
      };
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

        devShells.default =
          pkgs.mkShell { nativeBuildInputs = [ pkgs.neovim-base ]; };
      });
}
