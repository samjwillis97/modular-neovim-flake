# Nixvim Extensibility Refactor Plan

## Goal

Refactor the nixvim configuration to support project-specific extensions while maintaining a clean base configuration. This allows using the base neovim setup in development flakes and adding custom nixvim settings on top for specific projects (e.g., Gleam, Rust, etc.) without modifying the main repo.

## Requirements

- **Base configuration**: Continue to work as-is with `nix run .` or `packages.default`
- **Extension API**: Function-based approach for extending with project-specific config
- **Flexibility**: Support both override and extend capabilities
- **Module composition**: Leverage nixvim's module system for clean composition
- **Easy consumption**: Simple to use in project flakes

## Current Architecture

The current setup:
- Uses `nixvim.legacyPackages.${system}.makeNixvimWithModule` to build neovim
- Imports `./config` as the base module
- Exports as `packages.default`
- Module structure:
  - `config/default.nix` - Main module with imports
  - `config/plugins/` - Individual plugin configurations
  - `config/lsp/` - LSP configuration
  - Various config files for keymaps, opts, colorscheme, etc.

## Proposed Architecture

### 1. Create `lib.nix` - Extension Function Library

Create a new file `lib.nix` that exports helper functions for extending the base configuration.

**Functions to export:**

1. **`extend`** - Extend with inline nixvim configuration
   - Takes a single nixvim module (inline attribute set)
   - Merges with base module
   - Returns built neovim package

2. **`extendModules`** - Extend with a list of nixvim modules
   - Takes a list of nixvim module paths
   - Merges all modules with base module
   - Returns built neovim package

3. **`baseModule`** - Expose the base module
   - For advanced users who want to compose manually
   - Returns the imported `./config` module

**Implementation approach:**

```nix
{ system, nixpkgs, nixvim }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  baseModule = import ./config;

  # Helper to build nixvim with merged modules
  buildWithModules = modules:
    nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ baseModule ] ++ modules;
      };
      extraSpecialArgs = { inputs = { inherit nixpkgs nixvim; }; };
    };

  extend = module: buildWithModules [ module ];
  extendModules = modules: buildWithModules modules;
in
{
  inherit extend extendModules baseModule;
}
```

### 2. Update `flake.nix` - Export Library Functions

Modify the flake outputs to include the `lib` output per system:

```nix
outputs = { self, nixpkgs, flake-utils, nixvim }:
  flake-utils.lib.eachDefaultSystem (system: {
    # Existing outputs
    formatter = ...;
    checks.default = ...;
    packages.default = ...;
    devShells.default = ...;

    # New library output
    lib = import ./lib.nix {
      inherit system nixpkgs nixvim;
    };
  });
```

### 3. Usage Patterns

#### Pattern 1: Inline Extension (Simple)

For quick project-specific additions:

```nix
# In a Gleam project's flake.nix
{
  inputs.my-neovim.url = "github:samjwillis97/modular-neovim-flake";

  outputs = { self, nixpkgs, my-neovim, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          (my-neovim.lib.${system}.extend {
            plugins.lsp.servers.gleam = {
              enable = true;
              package = pkgs.gleam;
            };
            extraPlugins = [ pkgs.vimPlugins.gleam-vim ];
          })
        ];
      };
    };
}
```

#### Pattern 2: Module Extension (Complex)

For more complex project-specific configurations:

```nix
# In project's flake.nix
{
  inputs.my-neovim.url = "github:samjwillis97/modular-neovim-flake";

  outputs = { self, nixpkgs, my-neovim, ... }:
    let
      system = "x86_64-linux";

      # Project-specific neovim config module
      projectConfig = {
        imports = [
          ./neovim/gleam.nix
          ./neovim/custom-keymaps.nix
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          (my-neovim.lib.${system}.extend projectConfig)
        ];
      };
    };
}
```

#### Pattern 3: Multiple Modules

For splitting config across multiple files:

```nix
# In project's flake.nix
devShells.default = pkgs.mkShell {
  packages = [
    (my-neovim.lib.${system}.extendModules [
      ./neovim/gleam.nix
      ./neovim/custom-keymaps.nix
      ./neovim/project-specific.nix
    ])
  ];
};
```

#### Pattern 4: Advanced Composition

For users who want full control:

```nix
# Custom composition using the base module
let
  myNeovim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    module = {
      imports = [
        my-neovim.lib.${system}.baseModule
        ./my-override.nix
        { plugins.lsp.servers.gleam.enable = true; }
      ];
    };
  };
in
  # Use myNeovim...
```

### 4. Example Project Modules

**Example: `neovim/gleam.nix` in a Gleam project**

```nix
{ pkgs, ... }:
{
  plugins.lsp.servers.gleam = {
    enable = true;
    package = pkgs.gleam;
  };

  extraPlugins = with pkgs.vimPlugins; [
    gleam-vim
  ];

  plugins.conform.settings.formatters_by_ft.gleam = [ "gleam" ];

  # Add project-specific keymaps
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

## Benefits

1. **Clean separation**: Base config stays clean and project-agnostic
2. **Reusability**: Same base neovim across all projects
3. **Flexibility**: Can override or extend any part of the config
4. **Type safety**: Leverages nixvim's module system and type checking
5. **Composability**: Can chain multiple modules together
6. **Version control**: Each project can pin to a specific version of the base config
7. **No duplication**: Don't need to copy config, just extend it

## Implementation Steps

1. Create `lib.nix` with `extend`, `extendModules`, and `baseModule` functions
2. Update `flake.nix` to export the library per system
3. Test with a sample project (e.g., a Gleam dev shell)
4. Document usage patterns in README
5. Consider adding example project modules in an `examples/` directory

## Potential Enhancements (Future)

- **Preset modules**: Ship common language/framework presets (e.g., `presets.gleam`, `presets.rust`)
- **Overlay support**: Allow overriding specific parts of base config more explicitly
- **Config validation**: Helper to validate that extensions don't conflict
- **Multi-version support**: Support multiple base config versions/profiles

## Migration Path

Existing users:
- No changes needed - `packages.default` continues to work as before
- Can start using extension API when needed for project-specific setups

New users:
- Can use as a base config and extend per project
- Or use as-is if no extensions needed
