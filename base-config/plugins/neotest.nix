{
  plugins.neotest = {
    enable = true;

    # Lazy load on Neotest commands
    lazyLoad.settings = {
      cmd = "Neotest";
    };

    # No adapters configured by default - users add their own
    adapters = {
      # Example: Add test adapters in your extension
      # jest.enable = true;
      # vitest.enable = true;
      # playwright.enable = true;
      # pytest.enable = true;
      # go.enable = true;
      # rust.enable = true;
    };

    settings = {
      summary = {
        open = "topleft vsplit | vertical resize 60";
      };
    };
  };
}
