{ pkgs, ... }:
{
  # Language-specific DAP adapters
  # These extend the base DAP configuration with concrete adapters
  plugins = {
    # Go debugging
    dap-go = {
      enable = true;
      settings = {
        delve.path = "${pkgs.delve}/bin/dlv";
      };
    };

    # Add other language-specific DAP plugins here as needed
    # dap-python.enable = true;
    # dap-ui already enabled in base
  };
}
