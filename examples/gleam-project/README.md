# Gleam Project Example

This example demonstrates how to extend the base neovim configuration for a Gleam project using separate module files for better organization.

## Structure

```
gleam-project/
├── flake.nix           # Main flake with dev shell configuration
└── neovim/
    ├── gleam.nix       # Gleam LSP and plugin configuration
    └── keymaps.nix     # Gleam-specific keybindings
```

## What's Included

### LSP Configuration
- Gleam language server enabled
- Automatic type checking and completion
- Hover documentation and signature help

### Formatting
- `gleam format` integration via conform.nvim
- Automatic formatting on save (if configured in base)

### Custom Keymaps

All keymaps use the `<leader>g` prefix for Gleam commands:

- `<leader>gt` - Run Gleam tests
- `<leader>gb` - Build Gleam project
- `<leader>gr` - Run Gleam project
- `<leader>gf` - Format current Gleam file
- `<leader>gc` - Run Gleam type check

### File-Specific Settings
- 2-space indentation for Gleam files
- Expanded tabs (spaces instead of tabs)

## Usage

1. Copy this example structure to your Gleam project
2. Update the flake input URL to point to your fork or the main repo
3. Run `nix develop` to enter the dev shell
4. Launch neovim with all Gleam tooling configured

```bash
cd your-gleam-project
nix develop
nvim
```

## Customization

### Adding More Plugins

Edit `neovim/gleam.nix` and add plugins to `extraPlugins`:

```nix
extraPlugins = with pkgs.vimPlugins; [
  # Your additional plugins here
];
```

### Changing Keymaps

Edit `neovim/keymaps.nix` to add, remove, or modify keybindings.

### Adding More Modules

Create additional `.nix` files in the `neovim/` directory and add them to the `extendModules` list in `flake.nix`:

```nix
(my-neovim.lib.${system}.extendModules [
  ./neovim/gleam.nix
  ./neovim/keymaps.nix
  ./neovim/your-new-module.nix
])
```

## Testing

You can test the configuration without entering the full dev shell:

```bash
nix develop -c nvim
```

Or build the extended neovim package directly:

```bash
nix build .#devShells.x86_64-linux.default
```
