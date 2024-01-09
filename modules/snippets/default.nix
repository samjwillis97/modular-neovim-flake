{ lib, config, ... }:
with lib;
with builtins;
let cfg = config.vim.snippets;
in {
  options.vim.snippets = {
    enable = mkEnableOption "snippets";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ "luasnip" "friendly-snippets" ];

    vim.luaConfigRC.snippets = nvim.dag.entryAnywhere ''
      local ls = require("luasnip")

      ls.setup()

      require("luasnip.loaders.from_vscode").lazy_load()

      vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

      vim.keymap.set({"i", "s"}, "<C-E>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, {silent = true})
    '';

  };
}
