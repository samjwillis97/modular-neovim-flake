{ lib }:
let
  typesDag = import ./types-dag.nix { inherit lib; };
  typesPlugin = import ./types-plugin.nix { inherit lib; };
  typesLanguages = import ./types-languages.nix { inherit lib; };
in {
  inherit (typesDag) dagOf;
  inherit (typesPlugin) pluginsOpt;
  inherit (typesLanguages) mkGrammarOption;
}
