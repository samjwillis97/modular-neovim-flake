{
  plugins.treesitter = {
    enable = true;

    # Load when reading a buffer for syntax highlighting
    lazyLoad.settings = {
      event = "DeferredUIEnter";
    };

    nixvimInjections = true;
    nixGrammars = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
