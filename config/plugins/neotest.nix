{
  plugins.neotest = {
    enable = true;

    adapters = {
      jest = {
        enable = true;
      };
      vitest = {
        enable = true;
      };
      # playwright = {
      #   enable = true;
      # };
    };

    settings = {
      summary = {
        open = "topleft vsplit | vertical resize 60";
      };
    };
  };
}
