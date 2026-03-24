# TypeScript Debugger Example
#
# This shows how to extend the base neovim config with Node.js debugging
# support using a separate module for DAP configuration.

{
  description = "TypeScript Express project with Node.js debugging";

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
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = [
            # Extend base neovim with JS/TS debugging configuration
            (my-neovim.lib.${system}.extendModules [
              ./neovim/debugger.nix
            ])

            # Node.js tooling
            pkgs.nodejs
            pkgs.nodePackages.typescript
          ];

          shellHook = ''
            echo "TypeScript debugging environment loaded!"
            echo ""
            echo "Setup:"
            echo "  npm install          - Install dependencies"
            echo "  npx tsc              - Compile TypeScript"
            echo ""
            echo "Debugging:"
            echo "  1. Open src/index.ts in neovim"
            echo "  2. Set breakpoints with <leader>bb"
            echo "  3. Start debugging with <leader>dd"
            echo "     - 'Launch current file' to debug the current file"
            echo "     - 'Attach' to connect to a running node --inspect process"
            echo ""
            echo "To start with --inspect for attach mode:"
            echo "  node --inspect=9229 dist/index.js"
          '';
        };
      };
    };
}
