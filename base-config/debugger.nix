{ pkgs, ... }:
{
  keymaps = [
    {
      key = "<leader>bb";
      action = "<CMD>lua require('dap').toggle_breakpoint()<CR>";
      options.desc = "Toggle breakpoint";
    }
    {
      key = "<leader>dd";
      action = "<CMD>lua require('dap').run()<CR>";
      options.desc = "Start debugging";
    }
    {
      key = "<leader><leader>";
      action = "<CMD>lua require('dap').terminate()<CR>";
      options.desc = "Stop debugging";
    }
    {
      key = "<up>";
      action = "<CMD>lua require('dap').continue()<CR>";
      options.desc = "Debugging: continue";
    }
  ];

  highlightOverride = {
    "DapBreakpoint" = {
      fg = "#E06C75";
    };
    "DapLogPoint" = {
      fg = "#61afef";
    };
    "DapStopped" = {
      fg = "#98c379";
    };
  };

  plugins = {
    dap = {
      enable = true;

      signs = {
        "dapBreakpoint" = {
          text = "";
          texthl = "DapBreakpoint";
          linehl = "DapBreakpoint";
          numhl = "DapBreakpoint";
        };
        "dapBreakpointCondition" = {
          text = "";
          texthl = "DapBreakpoint";
          linehl = "DapBreakpoint";
          numhl = "DapBreakpoint";
        };
        "dapLogPoint" = {
          text = "";
          texthl = "DapLogPoint";
          linehl = "DapLogPoint";
          numhl = "DapLogPoint";
        };
        "dapStopped" = {
          text = "";
          texthl = "DapStopped";
          linehl = "DapStopped";
          numhl = "DapStopped";
        };
        "dapBreakpointRejected" = {
          text = "";
          texthl = "DapBreakpoint";
          linehl = "DapBreakpoint";
          numhl = "DapBreakpoint";
        };
      };

      # No adapters configured by default - users add their own
      adapters = {
        # Example: Add language-specific adapters in your extension
        # See: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
      };

      # No configurations by default - users add their own
      configurations = {
        # Example: Add debug configurations in your extension
        # javascript = [ { type = "pwa-node"; request = "launch"; ... } ];
      };
    };

    dap-ui = {
      enable = true;

      settings = {
        layouts = [
          {
            elements = [
              {
                id = "scopes";
                size = 0.5;
              }
              "breakpoints"
              "watches"
              "stacks"
            ];
            size = 50; # 50 columns
            position = "left";
          }
          {
            elements = [
              "repl"
              "watches"
            ];
            size = 25; # 25%
            position = "bottom";
          }
        ];
      };
    };

    dap-virtual-text = {
      enable = true;
    };

    # Language-specific DAP plugins should be added in extensions
    # Example in full-config:
    # dap-go.enable = true;
    # dap-python.enable = true;
  };
}
