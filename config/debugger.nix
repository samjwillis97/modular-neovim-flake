{pkgs, ...}:
let
  jsConfiguration = [
    {
      name = "Launch file";
      type = "pwa-node";
      request = "launch";
      # program = "${file}";
      # cwd = "${workspaceFolder}";
    }
  ];
in
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

  plugins.dap = {
    enable = true;

    adapters = {
      servers = {
        "pwa-node" = {
          host = "localhost";
          port = 8123;
          executable = {
            command = "${pkgs.vscode-js-debug}/bin/js-debug";
          };
        };
      };
    };

    configurations = {
      javascript = jsConfiguration;
      typescript = jsConfiguration;
    };

    extensions = {
      dap-ui = {
        enable = true;
      };
    };
  };
}

