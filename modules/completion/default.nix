{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.autocomplete;

  builtSources = concatMapStringsSep "\n" (n: "{ name = '${n}'},") (attrNames cfg.sources);

  builtMaps = concatStringsSep "\n" (
    mapAttrsToList (n: v: if v == null then "" else "${n} = '${v}',") cfg.sources
  );

  dagPlacement = nvim.dag.entryAfter [
    "lspkind"
    "snippets"
  ];
in
{
  options.vim.autocomplete = {
    enable = mkEnableOption "autocomplete";

    sources = mkOption {
      description = nvim.nmd.asciiDoc ''
        Attribute set of source names for nvim-cmp.

        If an attribute set is provided, then the menu value of
        `vim_item` in the format will be set to the value (if
        utilizing the `nvim_cmp_menu_map` function).

        Note: only use a single attribute name per attribute set
      '';
      type = with types; attrsOf (nullOr str);
      default = { };
      example = ''
        {nvim-cmp = null; buffer = "[Buffer]";}
      '';
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [
      "nvim-cmp"
      "cmp-buffer"
      "cmp-path"
      "cmp_luasnip"
    ];

    vim.autocomplete.sources = {
      "nvim-cmp" = null;
      "luasnip" = "[Snippet]";
      "buffer" = "[Buffer]";
      "crates" = "[Crates]";
      "path" = "[Path]";
    };

    vim.luaConfigRC.completion = dagPlacement ''
      local nvim_cmp_menu_map = function(entry, vim_item)
        -- name for each source
        vim_item.menu = ({
          ${builtMaps}
        })[entry.source.name]
        print(vim_item.menu)
        return vim_item
      end

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require'luasnip'.lsp_expand(args.body)
          end
        },
        sources = {
          ${builtSources}
        },
        mapping = {
          ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c'}),
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ['<CR>'] = cmp.mapping.confirm({
            select = true,
          }),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c'}),
          ['<C-n>'] = cmp.mapping(function (fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif ls.expand_or_jumpable() then
              ls.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            end
          end, { 'i', 's' }),
          ['<C-p>'] = cmp.mapping(function (fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif ls.jumpable(-1) then
              ls.jump(-1)
            end
          end, { 'i', 's' })
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },

        -- See: https://github.com/fitrh/init.nvim/blob/main/lua/config/plugin/cmp/setup.lua#L39-L56
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local kind = item.kind
            local kind_hl_group = ("CmpItemKind%s"):format(kind)

            item.kind_hl_group = kind_hl_group
            item.kind = (" %s "):format(lspkind.symbolic(kind))

            item.menu_hl_group = kind_hl_group
            item.menu = kind

            local third_win_width = math.floor(vim.api.nvim_win_get_width(0) / 3)
            if vim.api.nvim_strwidth(item.abbr) > third_win_width then
              item.abbr = ("%s…"):format(item.abbr:sub(1, third_win_width))
            end
            item.abbr = ("%s "):format(item.abbr)

            return item
          end,
        }
      })
      ${optionalString (config.vim.qol.autopairs.enable) ''
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { text = ""} }))
      ''}
    '';

    vim.snippets.enable = true;
  };
}
