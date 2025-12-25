{
  plugins.treesitter = {
    enable = true;

    folding = true;

    nixvimInjections = true;
    nixGrammars = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
