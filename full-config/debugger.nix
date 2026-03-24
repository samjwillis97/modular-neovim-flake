{ pkgs, ... }:
{
  # Language-specific DAP adapters
  # These extend the base DAP configuration with concrete adapters
  plugins = {
    # ── Go debugging ──────────────────────────────────────────────────
    # Note: dap-go's setup is called inside nvim-dap's after hook by nixvim,
    # so we don't give it independent lazy-load settings. It loads when
    # nvim-dap loads.
    dap-go = {
      enable = true;

      settings = {
        delve.path = "${pkgs.delve}/bin/dlv";
      };
    };

    # ── JavaScript / TypeScript (Node.js) debugging ───────────────────
    # Unlike Go which has a dedicated dap-go nixvim plugin, JS/TS requires
    # manual adapter + configuration via the base dap plugin settings.

    # pwa-node adapter: uses vscode-js-debug as a DAP server
    dap.adapters = {
      pwa-node = {
        __raw = ''
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
    };

    # DAP launch/attach configurations for JS/TS filetypes
    dap.configurations =
      let
        common = {
          sourceMaps = true;
          cwd = "\${workspaceFolder}";
          skipFiles = [ "<node_internals>/**" ];
        };

        jsConfigs = [
          # Attach to a running node --inspect process
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
        javascriptreact = jsConfigs;
        typescriptreact = jsConfigs;
      };

    # Add other language-specific DAP plugins here as needed
    # dap-python.enable = true;
    # dap-ui already enabled in base
  };
}
