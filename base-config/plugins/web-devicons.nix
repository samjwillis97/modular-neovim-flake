{
  plugins.web-devicons = {
    enable = true;

    # Don't lazy load - it's a small dependency plugin needed by multiple plugins
    # Loading it at startup ensures icons work everywhere
  };
}
