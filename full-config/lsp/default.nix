{
  # Language-specific LSP servers
  # These extend the base LSP configuration with concrete language servers
  plugins.lsp.servers = {
    # Nix
    nil_ls.enable = true;

    # Shell
    bashls.enable = true;

    # Go
    gopls.enable = true;

    # Lua
    lua_ls.enable = true;

    # TypeScript/JavaScript
    ts_ls.enable = true;

    # Web
    html.enable = true;
    eslint.enable = true;
    svelte.enable = true;

    # Python
    pyright.enable = true;

    # Data formats
    jsonls.enable = true;
    yamlls.enable = true;
  };
}
