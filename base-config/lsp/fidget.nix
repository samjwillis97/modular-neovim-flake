{
  plugins.fidget = {
    enable = true;

    # Load when LSP attaches
    lazyLoad.settings = {
      event = "LspAttach";
    };

    settings.progress = {
      suppress_on_insert = true;
      ignore_done_already = true;
      poll_rate = 1;
    };
  };
}
