{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.lsp;
in {
  imports = [ ./lspconfig.nix ];
  options.vim.lsp = {
    enable = mkEnableOption "lsp";
    # TODO: Format on save
  };

  config = mkIf cfg.enable {
    vim.luaConfigRC.lsp-setup = ''
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

      default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
        format_callback(client, bufnr)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
    '';
    # TODO: cmp
  };
}
