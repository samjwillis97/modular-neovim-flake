{
  # Import the base configuration
  imports = [
    ../base-config

    # Add language-specific extensions
    ./lsp
    # ./debugger.nix
    ./plugins
  ];

  # Enable Copilot autocomplete
  custom.copilot.autocomplete.enable = true;
}
