{ lib }:
{
  dag = import ./dag.nix { inherit lib; };
  types = import ./types.nix { inherit lib; };
  plugins = import ./plugins.nix { inherit lib; };
  languages = import ./languages.nix { inherit lib; };
}
