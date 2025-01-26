{pkgs, ...}:
let
  jsConfiguration = [
    # {
    #   name = "Launch file";
    #   type = "pwa-node";
    #   request = "launch";
    #   # program = "${file}";
    #   # cwd = "${workspaceFolder}";
    # }
  ];
  
  nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
    name = "vim-dap-vscode-js";
    src = pkgs.fetchFromGitHub {
      owner = "mxsdev";
      repo = "nvim-dap-vscode-js";
      rev = "e7c05495934a658c8aa10afd995dacd796f76091";
      sha256 = "sha256-lZABpKpztX3NpuN4Y4+E8bvJZVV5ka7h8x9vL4r9Pjk=";
    };
  };
in
{
  extraPlugins = [
    nvim-dap-vscode-js
  ];

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

  extraConfigLua = ''
    local dap, dapui = require("dap"), require("dapui")
    local dap_vscode_js = require("dap-vscode-js")

    -- DEBUG LISTENERS
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    dap.set_log_level('DEBUG')

    -- DEBUG VS CODE
    dap_vscode_js.setup({
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }
    })

    -- DEBUG CONFIG TYPESCRIPT
    dap.configurations.typescript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "''${file}",
        cwd = "''${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require'dap.utils'.pick_process,
        cwd = "''${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Run Application",
        program = "dist/index.js",
        cwd = "''${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Run npm test",
        program = "node_modules/mocha/bin/_mocha",
        cwd = "''${workspaceFolder}",
      }
    }
  '';

  plugins.dap = {
    enable = true;

    adapters = {
      # servers = {
      # };
    };

    configurations = {
      # javascript = jsConfiguration;
      # typescript = jsConfiguration;
    };

    extensions = {
      dap-ui = {
        enable = true;

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
            size = 25; # 25%?
            position = "bottom";
          }
        ];
      };
      dap-virtual-text = {
        enable = true;
      };
      dap-go = {
        enable = true;
        delve.path = "${pkgs.delve}/bin/dlv";
      };
    };
  };
}

