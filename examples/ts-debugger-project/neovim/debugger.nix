# JavaScript/TypeScript debugging configuration
#
# This module configures nvim-dap for Node.js debugging using vscode-js-debug.
# It adds the pwa-node adapter and debug configurations for JS/TS files.
#
# Debug configurations:
#   - Launch current file (node)    -- for .js or compiled output
#   - Launch current file (tsx)     -- runs .ts directly via tsx (fast, esbuild-based)
#   - Launch current file (ts-node) -- runs .ts directly via ts-node
#   - Launch npm script             -- runs an npm script with --inspect
#   - Attach to process             -- connects to a running node --inspect process

{ pkgs, ... }:
{
  plugins.dap = {
    # Configure the vscode-js-debug adapter
    adapters = {
      "pwa-node".__raw = ''
        {
          type = "server",
          host = "localhost",
          port = "''${port}",
          executable = {
            command = "${pkgs.vscode-js-debug}/bin/js-debug",
            args = { "''${port}" },
          },
        }
      '';
    };

    # Debug configurations for JavaScript and TypeScript
    configurations =
      let
        common = {
          sourceMaps = true;
          cwd = "\${workspaceFolder}";
          skipFiles = [ "<node_internals>/**" ];
        };

        jsConfigs = [
          (common
            // {
              type = "pwa-node";
              request = "launch";
              name = "Launch current file (node)";
              program = "\${file}";
            })
          (common
            // {
              type = "pwa-node";
              request = "launch";
              name = "Launch current file (tsx)";
              program = "\${file}";
              runtimeExecutable = "tsx";
            })
          (common
            // {
              type = "pwa-node";
              request = "launch";
              name = "Launch current file (ts-node)";
              program = "\${file}";
              runtimeExecutable = "node";
              runtimeArgs = [
                "--require"
                "ts-node/register"
              ];
            })
          (common
            // {
              type = "pwa-node";
              request = "launch";
              name = "Launch npm script";
              runtimeExecutable = "npm";
              runtimeArgs = [ "run" "debug" "--" "--inspect" ];
              console = "integratedTerminal";
            })
          (common
            // {
              type = "pwa-node";
              request = "attach";
              name = "Attach to process (port 9229)";
              port = 9229;
            })
        ];
      in
      {
        javascript = jsConfigs;
        typescript = jsConfigs;
        typescriptreact = jsConfigs;
        javascriptreact = jsConfigs;
      };
  };
}
