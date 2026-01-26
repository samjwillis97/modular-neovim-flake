# Example: Using the base config with Copilot autocomplete enabled
#
# This shows how easy it is to enable Copilot autocomplete with a single option.
# Use this in your project's flake.nix:

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
          (my-neovim.lib.${system}.extend {
            # Enable Copilot autocomplete - that's it!
            custom.copilot.autocomplete.enable = true;

            # Add your project-specific language server
            plugins.lsp.servers.gleam.enable = true;

            # Add formatters
            plugins.conform-nvim.settings.formatters_by_ft = {
              gleam = [ "gleam" ];
            };

            # Extra plugins
            extraPlugins = [ pkgs.vimPlugins.gleam-vim ];
          })
        ];
      };
    };
}
