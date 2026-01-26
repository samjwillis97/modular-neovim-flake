# Extension Examples

This directory contains examples of how to extend the base nixvim configuration for project-specific needs.

## Quick Start

Add this flake as an input to your project:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-neovim.url = "github:samjwillis97/modular-neovim-flake";
  };
}
```

## Extension Patterns

### 1. Inline Extension (Simplest)

Extend the base config with inline nixvim configuration:

```nix
{
  outputs = { self, nixpkgs, my-neovim, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          # Extend base neovim with inline config
          (my-neovim.lib.${system}.extend {
            plugins.lsp.servers.gleam.enable = true;
            extraPlugins = [ pkgs.vimPlugins.gleam-vim ];
          })
        ];
      };
    };
}
```

### 2. Module Extension

For more complex configurations, use a separate module file:

```nix
# flake.nix
{
  outputs = { self, nixpkgs, my-neovim, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Define your project-specific config
      projectConfig = import ./neovim-config.nix;
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          (my-neovim.lib.${system}.extend projectConfig)
        ];
      };
    };
}
```

```nix
# neovim-config.nix
{ pkgs, ... }:
{
  plugins.lsp.servers.gleam = {
    enable = true;
    package = pkgs.gleam;
  };

  extraPlugins = with pkgs.vimPlugins; [
    gleam-vim
  ];

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

### 3. Multiple Modules

Split your configuration across multiple files:

```nix
{
  devShells.default = pkgs.mkShell {
    packages = [
      (my-neovim.lib.${system}.extendModules [
        ./neovim/lsp.nix
        ./neovim/keymaps.nix
        ./neovim/plugins.nix
      ])
    ];
  };
}
```

### 4. Advanced Composition

For full control, use the base module directly:

```nix
let
  customNeovim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    module = {
      imports = [
        my-neovim.lib.${system}.baseModule
        ./my-overrides.nix
        { plugins.lsp.servers.custom.enable = true; }
      ];
    };
  };
in
  # Use customNeovim...
```

## Available Functions

### `lib.${system}.extend`

Extend the base configuration with a single inline module.

**Parameters:**
- `module`: A nixvim module (attribute set)

**Returns:** Neovim package with extended configuration

**Example:**
```nix
my-neovim.lib.${system}.extend {
  plugins.lsp.servers.rust_analyzer.enable = true;
}
```

### `lib.${system}.extendModules`

Extend the base configuration with multiple modules.

**Parameters:**
- `modules`: A list of nixvim modules (file paths or attribute sets)

**Returns:** Neovim package with extended configuration

**Example:**
```nix
my-neovim.lib.${system}.extendModules [
  ./neovim/lsp.nix
  ./neovim/keymaps.nix
  { extraPlugins = [ pkgs.vimPlugins.rust-vim ]; }
]
```

### `lib.${system}.baseModule`

Access the base nixvim module for advanced composition.

**Returns:** The base nixvim configuration module

**Example:**
```nix
{
  imports = [
    my-neovim.lib.${system}.baseModule
    ./my-custom-config.nix
  ];
}
```

## Example Configurations

See the example files in this directory:

- `simple-inline.nix` - Simple inline extension example
- `gleam-project/` - Complete Gleam project example with LSP and tooling
- `rust-project/` - Rust project with rust-analyzer and debugging
- `override-example.nix` - Example of overriding base config settings

## Tips

1. **Start simple**: Use inline extensions for quick additions
2. **Modularize**: Split complex configs into separate files
3. **Override carefully**: Base config uses sensible defaults; only override when necessary
4. **Test locally**: Use `nix develop` to test your dev shell before committing
5. **Pin versions**: Lock your neovim flake input to ensure reproducibility
