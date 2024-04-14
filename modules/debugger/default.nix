{ lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.debugger;
in
{
  options.vim.debugger = {
    enable = mkEnableOption "autocomplete";

    adapters = mkOption {
      description = "dap adapters";
      type = with types; attrsOf str;
      default = { };
    };

    configs = mkOption {
      description = "dap configurations";
      type = with types; attrsOf str;
      default = { };
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
      vim.startPlugins = [
        "dap"
        "dap-ui"
      ];

      vim.nnoremap = {
        "<leader>bb" = ":lua require'dap'.toggle_breakpoint()<CR>";
        "<leader>bc" = ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
        "<leader>rc" = ":lua require'dap'.run_to_cursor()<CR>";

        "<leader>dd" = ":lua require'dap'.run()<CR>";
        "<leader><leader>" = ":lua require'dap'.terminate()<CR>";

        "<up>" = ":lua require'dap'.continue()<CR>";
        "<down>" = ":lua require'dap'.step_over()<CR>";
        "<right>" = ":lua require'dap'.step_into()<CR>";
        "<left>" = ":lua require'dap'.step_out()<CR>";
      };

      vim.luaConfigRC.dap = nvim.dag.entryAnywhere ''
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup({
          mappings = {
            open = { "zo" },
            close = { "zc" },
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          layouts = {
            {
              elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.5 },
                "breakpoints",
                "watches",
                "stacks",
              },
              size = 50, -- 50 columns
              position = "left",
            },
            {
              elements = {
                "repl",
                "console",
              },
              size = 0.25, -- 25% of total lines
              position = "bottom",
            },
          },
          controls = {
            enabled = true,
            elements = "repl",
          },
        })

        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end
      '';
    }
    { vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryAfter [ "dap" ] v)) cfg.configs; }
    { vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryAfter [ "dap" ] v)) cfg.adapters; }
  ]);
}
