# Overlays for the Neovim flake
# This file contains package overrides to avoid building from source
{ inputs }:
let
  stablePkgs = inputs.nixpkgs-stable.legacyPackages;
in
[
  # Use .NET LSP servers from nixos-25.05 to avoid building Swift from source
  # Both roslyn-ls and omnisharp-roslyn depend on dotnet which depends on Swift
  # The stable versions use Swift 5.8 which is already cached
  # The unstable versions require Swift 5.10.1 which isn't cached
  (final: prev: {
    roslyn-ls = stablePkgs.${prev.system}.roslyn-ls;
    omnisharp-roslyn = stablePkgs.${prev.system}.omnisharp-roslyn;
  })
]
