{
  # FIXME: This plugin doesn't work as expected, especially in Go
  plugins.nvim-lightbulb = {
    enable = true;

    settings = {
      autocmd = {
        enabled = true;
        updatetime = 200;
      };
      # line = {
      #   enabled = true;
      # };
      virtual_text = {
        enabled = true;
        text = "💡";
        lens_text = "🔎";
      };
      # number = {
      #   enabled = true;
      # };
      # sign = {
      #   enabled = true;
      #   text = " 󰌶";
      # };
      # status_text = {
      #   enabled = true;
      #   text = " 󰌶 ";
      # };
    };
  };
}
