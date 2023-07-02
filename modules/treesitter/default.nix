{ pkgs, config, lib, ... }:
with lib;
with builtins;
let cfg = config.vim.treesitter;
in {
  options.vim.treesitter = {
    enable = mkEnableOption
      "treesitter, also enabled automatically through language options";

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
    # TODO: tree-sitter context
  };

  # TODO: Implement CMP at some point here, I have removed for now
  config = mkIf cfg.enable {
    vim.startPlugins = [ "nvim-treesitter" ] ++ (if cfg.context then [ "treesitter-context" ] else [ ]);

    # For some reason treesitter highlighting does not work on start if this is set before syntax on
    vim.configRC.treesitter-fold = mkIf cfg.fold
      (nvim.dag.entryBefore [ "base" ] ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      '');

    vim.luaConfigRC.treesitter = nvim.dag.entryAnywhere ''
      ${optionalString cfg.context "require('treesitter-context').setup()"}
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
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        }
      }
    '';
  };
}
