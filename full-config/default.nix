{
  # Import the base configuration
  imports = [
    ../base-config

    # Add language-specific extensions
    ./lsp
    ./debugger.nix
    ./plugins
  ];
}
