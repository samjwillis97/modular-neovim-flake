{
  description = "Sam's Modular Neovim Flake 🤭";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-bash-fix = {
      url = "github:NixOS/nixpkgs/91a7822b04fe5e15f1604f9ca0fb81eff61b4143";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    # Plugins
    plugin-plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    plugin-nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };
    plugin-telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    plugin-fugitive = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };
    plugin-gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    plugin-lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    plugin-nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    plugin-indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    plugin-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };
    plugin-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    plugin-nvim-lastplace = {
      url = "github:ethanholz/nvim-lastplace";
      flake = false;
    };
    plugin-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    plugin-lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };
    plugin-nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    plugin-cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    plugin-cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    plugin-luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    plugin-cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    plugin-friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };
    plugin-cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };
    plugin-cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    plugin-fidget = {
      url = "github:j-hui/fidget.nvim?ref=legacy";
      flake = false;
    };
    plugin-nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    plugin-colorizer = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };
    plugin-undotree = {
      url = "github:mbbill/undotree";
      flake = false;
    };
    plugin-harpoon = {
      url = "github:ThePrimeagen/harpoon";
      flake = false;
    };
    plugin-commentary = {
      url = "github:tpope/vim-commentary";
      flake = false;
    };
    plugin-surround = {
      url = "github:tpope/vim-surround";
      flake = false;
    };
    plugin-tmux-navigator = {
      url = "github:christoomey/vim-tmux-navigator";
      flake = false;
    };
    plugin-nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };
    plugin-formatter-nvim = {
      url = "github:mhartington/formatter.nvim";
      flake = false;
    };
    plugin-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    plugin-nio = {
      url = "github:nvim-neotest/nvim-nio";
      flake = false;
    };
    plugin-dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    plugin-nvim-dap-vscode-js = {
      url = "github:mxsdev/nvim-dap-vscode-js";
      flake = false;
    };
    plugin-transparent = {
      url = "github:xiyaowong/transparent.nvim";
      flake = false;
    };
    plugin-octo = {
      url = "github:samjwillis97/octo.nvim";
      flake = false;
    };
    plugin-copilot = {
      url = "github:github/copilot.vim";
      flake = false;
    };
    plugin-copilot-chat = {
      url = "github:CopilotC-Nvim/CopilotChat.nvim/canary";
      flake = false;
    };
    plugin-codesnap = {
      url = "github:mistricky/codesnap.nvim";
      flake = false;
    };
    plugin-rhubarb = {
      url = "github:tpope/vim-rhubarb";
      flake = false;
    };
    plugin-vim-sneak = {
      url = "github:justinmk/vim-sneak";
      flake = false;
    };
    plugin-nvim-ufo = {
      url = "github:kevinhwang91/nvim-ufo";
      flake = false;
    };
    plugin-promise-async = {
      url = "github:kevinhwang91/promise-async";
      flake = false;
    };

    # Themes
    plugin-tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    plugin-onedark = {
      url = "github:navarasu/onedark.nvim";
      flake = false;
    };
    plugin-catppuccin = {
      url = "github:catppuccin/nvim";
      flake = false;
    };
    plugin-dracula-nvim = {
      url = "github:Mofiqul/dracula.nvim";
      flake = false;
    };
    plugin-dracula = {
      url = "github:dracula/vim";
      flake = false;
    };
    plugin-gruvbox = {
      url = "github:ellisonleao/gruvbox.nvim";
      flake = false;
    };

    vscode-js-debug = {
      url = "github:samjwillis97/vscode-js-debug.nix";
      flake = true;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    let
      nvimLib = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib).nvim;
      rawPlugins = nvimLib.plugins.fromInputs inputs "plugin-";

      inherit (import ./lib/default.nix { inherit rawPlugins; }) mkNeovimConfiguration buildPkg;

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
        };
        #       # TODO: Finish Borders/No Borders
        #       # TODO: Dashboard
      };

      lspBase = baseConfig // {
        formatter.enable = true;
        treesitter = {
          enable = true;
        };
        folding = {
          enable = true;
          mode = "treesitter";
        };
        lsp = {
          enable = true;
          codeActionMenu.enable = true;
          lspconfig.enable = true;
          lspkind.enable = true;
        };
        autocomplete.enable = true;
      };

      fullConfig = lspBase // {
        languages = {
          enableTreesitter = true;
          enableLSP = true;
          enableDebugger = true;
          enableFormat = true;
          enableAll = true;
        };
        folding = {
          enable = true;
          mode = "ufo";
        };
        visuals = {
          enable = true;
          borderType = "none";
          transparentBackground = true;
        };
        debugger.enable = true;
        autocomplete = {
          enable = true;
        };
        ai = {
          copilot = {
            enableAll = true;
          };
        };
        nmap = {
          "<C-f>" = "<cmd>silent !tmux neww tmux-sessionizer<CR>";
        };
      };
    in
    #         # TODO: tailwind (tailwindcss-language-server)
    #         # TODO: angular (angularls)
    #         # TODO: rust lsp
    {

      # // Updates the left attribute set with the right, { ...left, ...right } in JS kinda
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [
          (prev: final: { vscode-js-debug = inputs.vscode-js-debug.packages.${system}.latest; })
          (prev: final: {
            inherit mkNeovimConfiguration;
            neovim-bare = buildPkg final [ { config.vim = bareConfig; } ];
            neovim-base = buildPkg final [ { config.vim = baseConfig; } ];
            neovim-full = buildPkg final [ { config.vim = fullConfig; } ];
          })
          # This shoudl be able to be removed soon, current bug
          (prev: final: {
            bash-language-server =
              inputs.nixpkgs-bash-fix.legacyPackages.${prev.system}.nodePackages.bash-language-server;
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        buildNeovimPackage = buildPkg;

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

        devShells.default = pkgs.mkShell { nativeBuildInputs = [ pkgs.neovim-full ]; };

        formatter = pkgs.nixfmt-rfc-style;
      }
    )
    // { };
}
