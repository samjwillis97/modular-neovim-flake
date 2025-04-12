{pkgs, inputs, lib, ...}:
let
  #  vscode-js-debug = pkgs.stdenv.mkDerivation rec {
  #   pname = "vscode-js-debug";
  #   version = "v1.85.0";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "microsoft";
  #     repo = pname;
  #     rev = version;
  #     hash = "sha256-mBXH3tqoiu3HIo1oZdQCD7Mq8Tvkt2DXfcoXb7KEgXE=";
  #   };
  #
  #   nativeBuildInputs = with pkgs; [
  #     python3
  #     nodejs
  #     cacert
  #   ] ++ lib.optionals pkgs.stdenv.isDarwin [
  #     darwin.cctools
  #   ];
  #   makeCacheWritable = true;
  #   dontNpmBuild = true;
  #
  #   configurePhase = ''
  #     runHook preConfigure
  #
  #     export HOME=$(pwd)
  #     npm install --legacy-peer-deps
  #
  #     runHook postConfigure
  #   '';
  #
  #   buildPhase = ''
  #     runHook preBuild
  #
  #     export HOME=$(pwd)
  #     npx gulp vsDebugServerBundle
  #     mkdir -p $out/out
  #     cp -r dist/* $out/out
  #
  #     runHook postBuild
  #   '';
  # };
  #
  
  # nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
  #   name = "vim-dap-vscode-js";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "mxsdev";
  #     repo = "nvim-dap-vscode-js";
  #     rev = "e7c05495934a658c8aa10afd995dacd796f76091";
  #     sha256 = "sha256-lZABpKpztX3NpuN4Y4+E8bvJZVV5ka7h8x9vL4r9Pjk=";
  #   };
  # };
in
{
  extraPlugins = [
    # nvim-dap-vscode-js
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

  # extraConfigLua = ''
    #   -- local dap, dapui = require("dap"), require("dapui")

    #   -- -- DEBUG VS CODE
    #   -- require("dap-vscode-js").setup({
    #   --   node_path = '${pkgs.nodejs_22}/bin/node',
    #   --   debugger_path = '${vscode-js-debug}',
    #   --   -- debugger_cmd = ,
    #   --   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    #   -- })

    #   -- DEBUG LISTENERS
    #   -- dap.listeners.before.attach.dapui_config = function()
    #   --   dapui.open()
    #   -- end
    #   -- dap.listeners.before.launch.dapui_config = function()
    #   --   dapui.open()
    #   -- end
    #   -- dap.listeners.before.event_terminated.dapui_config = function()
    #   --   dapui.close()
    #   -- end
    #   -- dap.listeners.before.event_exited.dapui_config = function()
    #   --   dapui.close()
    #   -- end
    #   --
    #   -- dap.set_log_level('DEBUG')
    #   --
    #   -- -- DEBUG CONFIG TYPESCRIPT
    #   -- dap.configurations.typescript = {
    #   --   {
    #   --     type = "pwa-node",
    #   --     request = "launch",
    #   --     name = "Launch file",
    #   --     program = "''${file}",
    #   --     cwd = "''${workspaceFolder}",
    #   --   },
    #   --   {
    #   --     type = "pwa-node",
    #   --     request = "attach",
    #   --     name = "Attach",
    #   --     processId = require'dap.utils'.pick_process,
    #   --     cwd = "''${workspaceFolder}",
    #   --   },
    #   --   {
    #   --     type = "pwa-node",
    #   --     request = "launch",
    #   --     name = "Run Application",
    #   --     program = "dist/index.js",
    #   --     cwd = "''${workspaceFolder}",
    #   --   },
    #   --   {
    #   --     type = "pwa-node",
    #   --     request = "launch",
    #   --     name = "Run npm test",
    #   --     program = "node_modules/mocha/bin/_mocha",
    #   --     cwd = "''${workspaceFolder}",
    #   --   }
    #   -- }
    #''   ;

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

  plugins.dap = {
    enable = true;

    signs = {
      "dapBreakpoint" = { text=""; texthl="DapBreakpoint"; linehl="DapBreakpoint"; numhl="DapBreakpoint"; };
      "dapBreakpointCondition" = { text=""; texthl="DapBreakpoint"; linehl="DapBreakpoint"; numhl="DapBreakpoint"; };
      "dapLogPoint" = { text=""; texthl="DapLogPoint"; linehl="DapLogPoint"; numhl="DapLogPoint"; };
      "dapStopped" = { text=""; texthl="DapStopped"; linehl="DapStopped"; numhl="DapStopped"; };
      "dapBreakpointRejected" = { text=""; texthl="DapBreakpoint"; linehl="DapBreakpoint"; numhl="DapBreakpoint"; };
    };

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

