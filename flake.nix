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
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };
    autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    nvim-lastplace = {
      url = "github:ethanholz/nvim-lastplace";
      flake = false;
    };
    lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim?ref=legacy";
      flake = false;
    };
    nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    colorizer = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };
    undotree = {
      url = "github:mbbill/undotree";
      flake = false;
    };
    harpoon = {
      url = "github:ThePrimeagen/harpoon";
      flake = false;
    };
    commentary = {
      url = "github:tpope/vim-commentary";
      flake = false;
    };
    surround = {
      url = "github:tpope/vim-surround";
      flake = false;
    };
    tmux-navigator = {
      url = "github:christoomey/vim-tmux-navigator";
      flake = false;
    };
    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
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
        "commentary"
        "surround"
        "nvim-tree-lua"
        "telescope"
        "fugitive"
        "gitsigns"
        "nvim-web-devicons"
        "lualine"
        "treesitter-context"
        "indent-blankline"
        "autopairs"
        "nvim-lastplace"
        "lspconfig"
        "lspkind"
        "nvim-cmp"
        "cmp-buffer"
        "cmp-vsnip"
        "cmp-path"
        "vim-vsnip"
        "cmp-treesitter"
        "cmp-nvim-lsp"
        "null-ls"
        "fidget"
        "nvim-code-action-menu"
        "colorizer"
        "undotree"
        "harpoon"
        "tmux-navigator"
        "nvim-ts-autotag"
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

      bareConfig = {
        filetree.enable = true;
        theme.enable = false;
        git.enable = false;
        visuals.enable = false;
        qol.enable = false;
        statusline.enable = false;
        treesitter.enable = false;
        telescope.enable = false;
        lsp.enable = false;
        autocomplete.enable = false;
      };

      baseConfig = bareConfig // {
        theme = {
          enable = true;
          name = "catppuccin";
        };
        filetree = {
          enable = true;
          location = "center";
        };
        qol.enable = true;
        #       # TODO: TODO comments
        #       # TODO: outline
        #       # TODO: which-key
        statusline.enable = true;
        telescope.enable = true;
        visuals = {
          enable = true;
          borderType = "none";
        };
        git.enable = true;
        treesitter = {
          enable = true;
          fold = true;
        };
        languages = {
          enableAll = true;
          enableTreesitter = true;
          enableLSP = false;
          enableFormat = false;
          enableExtraDiagnostics = false;
        };
        #       # TODO: Borders/No Borders
        #       # TODO: Dashboard
      };

      lspBase = baseConfig // {
        treesitter = {
          enable = true;
          fold = true;
        };
        lsp = {
          enable = true;
          codeActionMenu.enable = true;
          lspconfig.enable = true;
          lspkind.enable = true;
          null-ls.enable = true;
        };
        autocomplete.enable = true;
      };

      fullConfig = lspBase // {
        languages = {
          enableTreesitter = true;
          enableLSP = true;
          enableFormat = true;
          enableExtraDiagnostics = true;
          enableAll = true;
        };
      };

      #         # TODO: tailwind (tailwindcss-language-server)
      #         # TODO: angular (angularls)
      #         # TODO: csharp
      #         # TODO: json (jsonls)
      #         # TODO: yaml (yaml-language-server)
      #         # TODO: rust
    in
    {

      # // Updates the left attribute set with the right, { ...left, ...right } in JS kinda
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (prev: final: {
            inherit mkNeovimConfiguration;
            neovim-bare = buildPkg final [{ config.vim = bareConfig; }];
            neovim-base = buildPkg final [{ config.vim = baseConfig; }];
            neovim-full = buildPkg final [{ config.vim = fullConfig; }];
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        packages = rec {
          neovim-bare = pkgs.neovim-bare;
          neovim-base = pkgs.neovim-base;
          neovim-full = pkgs.neovim-full;
          default = neovim-base;
        };

        apps = rec {
          neovim-bare = flake-utils.lib.mkApp {
            drv = self.packages.${system}.neovim-bare;
            exePath = "/bin/nvim";
          };
          neovim-base = flake-utils.lib.mkApp {
            drv = self.packages.${system}.neovim-base;
            exePath = "/bin/nvim";
          };
          neovim-full = flake-utils.lib.mkApp {
            drv = self.packages.${system}.neovim-full;
            exePath = "/bin/nvim";
          };
          default = neovim-full;
        };

        devShells.default =
          pkgs.mkShell { nativeBuildInputs = [ pkgs.neovim-full ]; };
      });
}
