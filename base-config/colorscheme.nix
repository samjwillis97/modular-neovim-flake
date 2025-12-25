{
  colorschemes = {
    # ayu = {
    #   autoLoad = true;
    #   enable = true;
    #
    #   settings = {
    #     mirage = true;
    #     terminal = false;
    #   };
    # };
    catppuccin = {
      autoLoad = true;
      enable = true;

      settings = {
        flavour = "mocha";
        integrations = {
          cmp = true;
          gitsigns = true;
          treesitter = true;
          diffview = true;
          fidget = true;
          indent_blankline = {
            enabled = false;
          };
          neotree = true;
          dap = true;
          dap_ui = true;
          telescope  = {
            enabled = true;
          };
          which_key = true;

          native_lsp = {
            enabled = true;
            virtual_text = {
                errors = [ "italic" ];
                hints = [ "italic" ];
                warnings = [ "italic" ];
                information = [ "italic" ];
                ok = [ "italic" ];
            };
            underlines = {
                errors = [ "underline" ];
                hints = [ "underline" ];
                warnings = [ "underline" ];
                information = [ "underline" ];
                ok = [ "underline" ];
            };
            inlay_hints = {
                background = true;
            };
          };
        };

        transparent_background = false;

        dim_inactive = {
          enabled = true;
        };
      };
    };
    # dracula = {
    #   autoLoad = true;
    #   enable = true;
    # };
    # dracula-nvim = {
    #   autoLoad = true;
    #   enable = true;
    # };
    # gruvbox = {
    #   autoLoad = false;
    #   enable = true;
    # };
    # monokai-pro = {
    #   autoLoad = true;
    #   enable = true;
    # };
    # one = {
    #   autoLoad = true;
    #   enable = true;
    # };
    # onedark = {
    #   autoLoad = true;
    #   enable = true;
    #
    #   settings = {
    #     style = "dark";
    #   };
    # };
    # tokyonight = {
    #   autoLoad = false;
    #   enable = true;
    # };
  };
}
