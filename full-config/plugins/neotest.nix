{
  # Language-specific test adapters
  # These extend the base neotest configuration with concrete adapters
  plugins.neotest.adapters = {
    # JavaScript/TypeScript testing
    jest = {
      enable = true;
    };
    vitest = {
      enable = true;
    };

    # Add more test adapters as needed
    # playwright = {
    #   enable = true;
    # };
    # pytest = {
    #   enable = true;
    # };
    # go = {
    #   enable = true;
    # };
  };
}
