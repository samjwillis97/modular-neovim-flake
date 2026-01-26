{
  plugins.render-markdown = {
    enable = true;

    # Load on markdown, Avante filetypes, and when LSP attaches
    lazyLoad.settings = {
      ft = [
        "markdown"
        "Avante"
      ];
    };

    settings = {
      file_types = [
        "markdown"
        "Avante"
      ];

      code = {
        above = "▄";
        below = "▀";
        style = "normal";
      };
    };
  };
}
