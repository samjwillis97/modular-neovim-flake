{
  imports = [
    # Copilot autocomplete is now enabled via custom.copilot.autocomplete.enable in full-config/default.nix

    ./conform.nix
    ./neotest.nix

    # AI Assistant - Commented out because it requires Copilot authentication
    # which fails during nix flake check. Enable in your own config:
    #   imports = [ my-neovim.lib.${system}.fullModule ./my-avante-config.nix ];
    ./avante.nix

    ./diffview.nix
    ./actions-preview.nix
    ./yazi.nix
  ];
}
