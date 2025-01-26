{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.vim.treesitter;
  usingLsp = config.vim.lsp.enable;
  usingNvimCmp = config.vim.autocomplete.enable;
  foldMode = config.vim.folding.mode;
  transparentBackground = config.vim.visuals.transparentBackground;
in
{
  options.vim.treesitter = {
    enable = mkEnableOption "treesitter, also enabled automatically through language options";

    fold = mkEnableOption "fold with treesitter";

    grammars = mkOption {
      type = with types; listOf package;
      default = [ ];
      description = nvim.nmd.asciiDoc ''
        List of treesitter grammars to install. For supported languages
        use the `vim.languages.<language>.treesitter.enable` option
      '';
    };

    context = mkOption {
      type = types.bool;
      default = true;
      description = "Show current context at the top of the buffer using treesitter";
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
      vim.startPlugins = [ "nvim-treesitter" ];
      vim.luaConfigRC.treesitter = nvim.dag.entryAnywhere ''
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            disable = {},
          },

          auto_install = false,
          ensure_installed = {},

          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<CR>",
              scope_incremental = "<CR>",
              node_incremental = "<TAB>",
              node_decremental = "<S-TAB>",
            },
          }
        }
      '';
    }

    (mkIf (cfg.context) {
      vim.startPlugins = [ "treesitter-context" ];
      vim.luaConfigRC.treesitter-context = nvim.dag.entryAnywhere ''
        require('treesitter-context').setup({
          enable = true,
          line_numbers = true,
          multiline_threshold = 5,
          max_lines = 10,
        })
      '';
      vim.configRC.treesitter-context = nvim.dag.entryAnywhere ''
        hi TreesitterContextBottom gui=NONE ${optionalString transparentBackground "guibg=#202328"}
      '';
    })

    (mkIf (usingNvimCmp && !usingLsp) { vim.startPlugins = [ "cmp-treesitter" ]; })

    (mkIf (!usingLsp) {
      vim.autocomplete.sources = {
        "treesitter" = "[Treesitter]";
      };
    })

    (mkIf (foldMode == "treesitter") {
      # For some reason treesitter highlighting does not work on start if this is set before syntax on
      vim.configRC.treesitter-fold = nvim.dag.entryBefore [ "base" ] ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      '';
    })
  ]);
}
