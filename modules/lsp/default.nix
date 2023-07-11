{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.lsp;
  usingNvimCmp = config.vim.autocomplete.enable;
in
{
  imports = [ ./lspconfig.nix ./lspkind.nix ./null_ls.nix ./code-action.nix ];
  options.vim.lsp = {
    enable = mkEnableOption "lsp";

    formatOnSave = mkOption {
      type = types.bool;
      default = true;
      description = "Format files on save";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = optional usingNvimCmp "cmp-nvim-lsp";

    vim.autocomplete.sources = { "nvim_lsp" = "[LSP]"; };

    vim.luaConfigRC.lsp-setup = ''
      vim.g.formatsave = ${boolToString cfg.formatOnSave};

      local attach_keymaps = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
      end

      -- Enable formatting
      local format_callback = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            if vim.g.formatsave then
              if client.supports_method("textDocument/formatting") then
                local params = require'vim.lsp.util'.make_formatting_params({})
                client.request('textDocument/formatting', params, nil, bufnr)
              end
            end
          end
        })
      end

      default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
        format_callback(client, bufnr)
      end

      
      -- see: https://github.com/williamboman/mason-lspconfig.nvim/issues/211
      csharp_on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
        attach_keymaps(client, bufnr)
        format_callback(client, bufnr)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      ${optionalString usingNvimCmp
      "capabilities = require('cmp_nvim_lsp').default_capabilities()"}
    '';
  };
}
