{ pkgs, ... }:
{
  # Language-specific DAP adapters
  # These extend the base DAP configuration with concrete adapters
  plugins = {
    # Go debugging
    dap-go = {
      enable = true;

      # Lazy load on go filetype or when dap is triggered
      lazyLoad.settings = {
        ft = "go";
        keys = [
          "<leader>bb"
          "<leader>dd"
          "<leader><leader>"
          "<up>"
        ];
      };

      settings = {
        delve.path = "${pkgs.delve}/bin/dlv";
      };
    };

    # Add other language-specific DAP plugins here as needed
    # dap-python.enable = true;
    # dap-ui already enabled in base
  };
}
