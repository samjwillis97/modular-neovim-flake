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

## Configuration Variants

This flake provides two configuration variants:

### Base Configuration (`baseModule`)
A minimal, framework-only configuration with:
- Essential editor plugins (telescope, which-key, gitsigns, etc.)
- LSP/DAP/Formatter/Test frameworks **enabled but unconfigured**
- NO language-specific servers, adapters, or formatters
- NO AI tools (Copilot, Avante)

Perfect for extending with your own project-specific tools.

### Full Configuration (`fullModule`)
My personal complete configuration that extends the base with:
- Language servers: Nix, Bash, Go, Lua, TypeScript, Python, etc.
- Debug adapters: Go (dap-go)
- Formatters: stylua, prettier, gofmt
- Test adapters: Jest, Vitest

This serves as an example of how to extend the base configuration.

## Extension API

This flake provides a composable extension API, allowing you to build upon the base configuration for project-specific needs.

### Simple Inline Extension

Extend the **base** configuration with inline configuration:

```nix
my-neovim.lib.${system}.extend {
  # Add your language server
  plugins.lsp.servers.rust_analyzer.enable = true;

  # Add formatters
  plugins.conform-nvim.settings.formatters_by_ft = {
    rust = [ "rustfmt" ];
  };

  # Add test adapters
  plugins.neotest.adapters.rust.enable = true;

  # Add debug adapters
  plugins.dap-go.enable = true;
}
```

### Module-Based Extension

For complex configurations, use separate modules:

```nix
my-neovim.lib.${system}.extendModules [
  ./neovim/lsp.nix      # Your language servers
  ./neovim/formatters.nix
  ./neovim/keymaps.nix
  ./neovim/plugins.nix
]
```

### Using Full Configuration

To use the full configuration (with all my language-specific tools):

```nix
devShells.default = pkgs.mkShell {
  packages = [
    # Access the full module from lib
    (nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = my-neovim.lib.${system}.fullModule;
    })
  ];
};
```

### Advanced Composition

Access modules directly for full control:

```nix
nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    imports = [
      # Use base as foundation
      my-neovim.lib.${system}.baseModule

      # Add your own overrides
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

### Base Configuration
- **Modular structure** - Each plugin and feature in its own file
- **LSP framework** - Enabled but no servers configured by default
- **Modern completion** - Blink.cmp (Copilot optional)
- **Debugging framework** - nvim-dap with UI, no adapters by default
- **Formatter framework** - conform.nvim, no formatters by default
- **Test framework** - Neotest, no adapters by default
- **Git integration** - Gitsigns, Fugitive
- **Fuzzy finding** - Telescope with file, grep, and LSP pickers
- **UI enhancements** - Lualine, Which-key, Indent-blankline, and more

### Full Configuration (Example Extension)
Everything in base, plus:
- **LSP servers** - Nix, Bash, Go, Lua, TypeScript, HTML, Python, JSON, YAML
- **Debug adapters** - Go (dap-go)
- **Formatters** - stylua (Lua), prettier (JS/TS), gofmt (Go)
- **Test adapters** - Jest, Vitest
- **Additional plugins** - Diffview, Actions-preview, Yazi

## Project Structure

```
.
├── base-config/          # Minimal framework-only configuration
│   ├── lsp/             # LSP framework (no servers)
│   ├── plugins/         # Essential editor plugins
│   ├── blink.nix        # Completion (no Copilot)
│   ├── debugger.nix     # DAP framework (no adapters)
│   └── ...
├── full-config/          # Example extension with language-specific tools
│   ├── lsp/             # Language servers enabled
│   ├── plugins/         # Additional plugins
│   │   ├── conform.nix  # Formatters configured
│   │   ├── neotest.nix  # Test adapters configured
│   │   └── ...
│   └── debugger.nix     # Debug adapters enabled
├── lib.nix              # Exports baseModule, fullModule, extend, extendModules
└── flake.nix            # Default package uses fullModule
```

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
