{ lib, ... }:
let
  highlights = [
    {
      name = "RainbowRed";
      value = {
        fg = "#E06C75";
      };
    }
    {
      name = "RainbowYellow";
      value = {
        fg = "#E5C07B";
      };
    }
    {
      name = "RainbowBlue";
      value = {
        fg = "#61AFEF";
      };
    }
    {
      name = "RainbowOrange";
      value = {
        fg = "#D19A66";
      };
    }
    {
      name = "RainbowGreen";
      value = {
        fg = "#98C379";
      };
    }
    {
      name = "RainbowViolet";
      value = {
        fg = "#C678DD";
      };
    }
    {
      name = "RainbowCyan";
      value = {
        fg = "#56B6C2";
      };
    }
  ];

  highlightNames = map (x: x.name) highlights;
in
{
  opts = {
    list = true;
  };

  highlightOverride = lib.listToAttrs highlights;

  plugins.rainbow-delimiters = {
    enable = true;

    highlight = highlightNames;
  };

  plugins.indent-blankline = {
    enable = true;

    settings = {
      indent = {
        char = "▎";
        tab_char = "▎";
      };

      scope = {
        enabled = true;
        show_start = true;
        show_exact_scope = false;
        show_end = true;
        highlight = highlightNames;
        # whitespace.highlight = [ "Whitespace" ];
      };
    };

    luaConfig = {
      pre = ''
        local hooks = require("ibl.hooks")
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      '';
    };
  };
}
