# Simple Inline Extension Example
#
# This shows how to quickly extend the base neovim config
# with inline configuration for a project.
#
# Usage: Copy this pattern into your project's flake.nix

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-neovim.url = "github:samjwillis97/modular-neovim-flake";
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
      devShells.default = pkgs.mkShell {
        packages = [
          # Base neovim extended with project-specific config
          (my-neovim.lib.${system}.extend {
            # Enable Python LSP
            plugins.lsp.servers.pyright.enable = true;

            # Add Python-specific plugins
            extraPlugins = with pkgs.vimPlugins; [
              vim-python-pep8-indent
            ];

            # Add project-specific keymaps
            keymaps = [
              {
                mode = "n";
                key = "<leader>pt";
                action = "<cmd>!pytest<CR>";
                options.desc = "Run pytest";
              }
            ];

            # Override or extend conform formatters
            plugins.conform-nvim.settings.formatters_by_ft.python = [ "black" ];
          })

          # Other dev tools
          pkgs.python3
          pkgs.python3Packages.pytest
          pkgs.black
        ];

        shellHook = ''
          echo "Python development environment loaded!"
          echo "Neovim ready with Python LSP and tooling"
        '';
      };
    };
}
