{ pkgs, lib, ... }:
{
  # Language-specific formatters
  # These extend the base conform configuration with concrete formatters
  plugins.conform-nvim.settings = {
    formatters_by_ft = {
      # Lua
      lua = [ "stylua" ];

      # JavaScript/TypeScript
      javascript = [ "prettier" ];
      typescript = [ "prettier" ];

      # Go
      go = [ "gofmt" ];

      # Add more formatters as needed
      # python = [ "black" ];
      # rust = [ "rustfmt" ];
      # nix = [ "nixfmt" ];
    };

    formatters = {
      # Custom formatter configurations
      shellcheck = {
        command = lib.getExe pkgs.shellcheck;
      };

      # Prettier with dynamic lookup
      prettier.__raw = ''
        function(bufnr)
          local prettierExists = vim.fn.executable('prettier') == 1
          if prettierExists == true then
            prettierScript = "prettier"
          else
            prettierScript = ""
          end
          return {
            command = prettierScript,
          }
        end
      '';
    };
  };
}
