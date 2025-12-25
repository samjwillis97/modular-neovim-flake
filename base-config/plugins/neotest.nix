{
  plugins.neotest = {
    enable = true;

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
