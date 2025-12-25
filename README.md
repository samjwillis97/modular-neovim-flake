# My Modular Neovim

![Screenshot 2024-01-10 at 12 54 13 pm](https://github.com/samjwillis97/modular-neovim-flake/assets/37866085/9bc6329e-e874-408c-9ba7-6b427d8bc3a7)

A modular, extensible Neovim configuration built with Nix and nixvim. Use it standalone or as a base configuration for your project-specific development environments.

Inspired by the likes of:
- [jordanisaacs](https://github.com/jordanisaacs/neovim-flake)
- [wiltaylor](https://github.com/wiltaylor/neovim-flake)

## Quick Start

### Run Directly

```bash
nix run github:samjwillis97/modular-neovim-flake
```

### Use in Your Project

Add to your project's `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-neovim.url = "github:samjwillis97/modular-neovim-flake";
  };

  outputs = { self, nixpkgs, my-neovim, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          # Use base config as-is
          my-neovim.packages.${system}.default

          # Or extend with project-specific config
          (my-neovim.lib.${system}.extend {
            plugins.lsp.servers.rust_analyzer.enable = true;
          })
        ];
      };
    };
}
```

## Extension API

This flake provides a composable extension API, allowing you to build upon the base configuration for project-specific needs.

### Simple Inline Extension

Extend with inline configuration:

```nix
my-neovim.lib.${system}.extend {
  plugins.lsp.servers.gleam.enable = true;
  extraPlugins = [ pkgs.vimPlugins.gleam-vim ];
  keymaps = [
    {
      mode = "n";
      key = "<leader>gt";
      action = "<cmd>!gleam test<CR>";
      options.desc = "Run Gleam tests";
    }
  ];
}
```

### Module-Based Extension

For complex configurations, use separate modules:

```nix
my-neovim.lib.${system}.extendModules [
  ./neovim/lsp.nix
  ./neovim/keymaps.nix
  ./neovim/plugins.nix
]
```

### Advanced Composition

Access the base module directly for full control:

```nix
nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    imports = [
      my-neovim.lib.${system}.baseModule
      ./my-overrides.nix
    ];
  };
}
```

## Examples

See the [`examples/`](./examples/) directory for complete examples:

- **simple-inline.nix** - Quick inline extension for Python projects
- **gleam-project/** - Full Gleam project setup with LSP, keymaps, and formatting

## Features

- **Modular structure** - Each plugin and feature in its own file
- **LSP support** - Pre-configured language servers (Nix, TypeScript, Python, Go, Lua, etc.)
- **Modern completion** - Blink.cmp with Copilot integration
- **Debugging** - nvim-dap with UI and language-specific adapters
- **Git integration** - Gitsigns, Fugitive, Diffview
- **Testing** - Neotest framework
- **Fuzzy finding** - Telescope with file, grep, and LSP pickers
- **UI enhancements** - Lualine, Which-key, Indent-blankline, and more

## Helpful Commands

Shows which init file was loaded:
```vim
:scriptnames
```

Check Treesitter health:
```vim
:checkhealth nvim-treesitter
```

## Development

```bash
# Enter dev shell
nix develop

# Run checks
nix flake check

# Format code
nix fmt
```

## To Address

- Treesitter errors, `:checkhealth nvim-treesitter`
