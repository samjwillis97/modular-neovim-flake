{
  plugins.ts-comments = {
    enable = true;

    # Load only when using comment operations
    lazyLoad.settings = {
      keys = [
        "gcc"
        "gbc"
        "gc"
        "gb"
      ];
    };
  };
}
