{ lib, ... }:
with lib;
let
  mkEnable = desc:
    mkOption {
      description = "Turn on ${desc} for enabled languages by default";
      type = types.bool;
      default = false;
    };
in
{
  imports = [
    ./nix
    ./typescript
    ./html
    ./python
    ./go
    ./css
    ./svelte
    ./terraform
    ./json
    ./yaml
    ./bash
    ./csharp
    ./elixir
    ./ocaml
    ./rust
    ./lua
  ];
  options.vim.languages = {
    enableAll = mkEnable "all Languages";
    enableLSP = mkEnable "LSP";
    enableTreesitter = mkEnable "treesitter";
    enableFormat = mkEnable "formatting";
    enableDebugger = mkEnable "debugger";
  };
}
