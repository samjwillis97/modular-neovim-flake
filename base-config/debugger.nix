{ pkgs, ... }:
{
  keymaps = [
    {
      key = "<leader>du";
      action = "<cmd>DapViewToggle<CR>";
      options.desc = "Toggle DAP view";
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

      # Lazy load on DAP commands and keymaps
      lazyLoad.settings = {
        keys = [
          {
            __unkeyed-1 = "<leader>bb";
            __unkeyed-2.__raw = "function() require('dap').toggle_breakpoint() end";
            desc = "Toggle breakpoint";
          }
          {
            __unkeyed-1 = "<leader>dd";
            __unkeyed-2.__raw = "function() require('dap').continue() end";
            desc = "Start/continue debugging";
          }
          {
            __unkeyed-1 = "<leader><leader>";
            __unkeyed-2.__raw = "function() require('dap').terminate() end";
            desc = "Stop debugging";
          }
          {
            __unkeyed-1 = "<up>";
            __unkeyed-2.__raw = "function() require('dap').continue() end";
            desc = "Debugging: continue";
          }
        ];
      };

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

    dap-view = {
      enable = true;

      lazyLoad.settings = {
        cmd = [
          "DapViewOpen"
          "DapViewClose"
          "DapViewToggle"
          "DapViewWatch"
        ];
      };

      settings = {
        winbar = {
          controls = {
            enabled = true;
            position = "right";
          };
        };
        windows = {
          position = "below";
        };
        auto_toggle = true;
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
