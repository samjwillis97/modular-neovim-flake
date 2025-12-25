{ pkgs, lib, ... }:
{
  plugins.conform-nvim = {
    enable = true;

    settings = {
      log_level = "trace";
      notify_no_formatters = false;

      # No formatters configured by default - users add their own
      formatters_by_ft = {
        # Example: Add formatters in your extension
        # lua = [ "stylua" ];
        # javascript = [ "prettier" ];
        # typescript = [ "prettier" ];
        # python = [ "black" ];
        # go = [ "gofmt" ];
        # rust = [ "rustfmt" ];
      };

      # Custom formatter configurations can be added here
      formatters = {
        # Example: Override formatter command
        # prettier = {
        #   command = lib.getExe pkgs.nodePackages.prettier;
        # };
      };

      # Format on save with timeout and LSP fallback
      format_on_save.__raw = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          return { timeout_ms = 200, lsp_fallback = true }
        end
      '';
    };

    # Commands to enable/disable formatting
    luaConfig = {
      post = ''
        vim.api.nvim_create_user_command("FormatDisable", function(args)
          if args.bang then
            -- FormatDisable! will disable formatting just for this buffer
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end, {
          desc = "Disable autoformat-on-save",
          bang = true,
        })

        vim.api.nvim_create_user_command("FormatEnable", function()
          vim.b.disable_autoformat = false
          vim.g.disable_autoformat = false
        end, {
          desc = "Re-enable autoformat-on-save",
        })
      '';
    };
  };
}
