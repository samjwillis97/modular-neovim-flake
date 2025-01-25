{
  plugins.copilot-lua = {
    enable = true;
  };

  plugins.avante = {
    enable = true;

    settings = {
      provider = "copilot";
      auto_suggestions_frequency = "copilot";

      hints = {
        enabled = true;
      };

      behaviour = {
        auto_suggestions = false;
      };
    };
  };
}
