{ pkgs, lib, ... }:
{
  # Language-specific LSP servers
  # These extend the base LSP configuration with concrete language servers
  plugins.lsp.servers = {
    # Nix
    nixd = {
      enable = true;
      settings.formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
    };

    # Shell
    bashls.enable = true;

    # Go
    gopls.enable = true;

    # Lua
    lua_ls.enable = true;

    # Dotnet
    roslyn_ls.enable = false;
    omnisharp.enable = true;

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
