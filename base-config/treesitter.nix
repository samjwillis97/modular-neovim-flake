{
  plugins.treesitter = {
    enable = true;

    folding.enable = true;

    nixvimInjections = true;
    nixGrammars = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
