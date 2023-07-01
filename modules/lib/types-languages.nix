{ lib }:
with lib; {
  mkGrammarOption = pkgs: grammar:
    mkPackageOption pkgs [ "${grammar} treesitter" ] {
      default = [ "vimPlugins" "nvim-treesitter" "builtGrammars" grammar ];
    };
}
