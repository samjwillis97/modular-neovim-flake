{ pkgs, lib, ... }:
{
  plugins.conform-nvim = {
    enable = true;

    settings = {
      log_level = "trace";

      notify_no_formatters = false;

      formatters_by_ft = {
        lua = [ "stylua" ];
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
        go = [ "gofmt" ];
        # nix = [ "nixfmt" ];
      };

      formatters = {
        # gofmt = {
        #   command = lib.getExe pkgs.gofmt;
        # };

        # nixfmt = {
        #   comamand = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        # };

        shellcheck = {
          command = lib.getExe pkgs.shellcheck;
        };

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

      format_on_save.__raw = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          return { timeout_ms = 200, lsp_fallback = true }, on_format
         end
      '';
    };
  };
}
