{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.typescript;

  enabledServerConfigs = listToAttrs (
    map (v: {
      name = v;
      value = servers.${v}.lspConfig;
    }) cfg.lsp.servers
  );
  enabledServerPackages = listToAttrs (
    map (v: {
      name = v;
      value = servers.${v}.package;
    }) cfg.lsp.servers
  );

  defaultServers = [
    "tsserver"
  ];
  servers = {
    tsserver = {
      package = pkgs.nodePackages.typescript-language-server;
      lspConfig = ''
        lspconfig.tsserver.setup {
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = { "${enabledServerPackages.tsserver}/bin/typescript-language-server", "--stdio" }
        }
      '';
    };
    eslint = {
      package = pkgs.nodePackages.vscode-langservers-extracted;
      lspConfig = ''
        lspconfig.eslint.setup {
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = { "${enabledServerPackages.eslint}/bin/vscode-eslint-language-server", "--stdio" }
        }
      '';
    };
    # FIXME: This doesn't actually exist - trying to add it though, cannot execute see: 
    # https://github.com/angular/vscode-ng-language-service/issues/1899
    # okay this is fucking me
    angularls = {
      package = pkgs.vscode-ng-language-service;
      lspConfig = ''
        lspconfig.angularls.setup {
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = { "${enabledServerPackages.angularls}/bin/ngserver"}
        }
      '';
    };
  };

  enabledDebuggerPackages = listToAttrs (
    map (v: {
      name = v;
      value = debuggers.${v}.package;
    }) cfg.debugger.debuggers
  );
  enabledDebuggerConfigs = listToAttrs (
    map (v: {
      name = "${v}-config";
      value = debuggers.${v}.dapConfig;
    }) cfg.debugger.debuggers
  );
  enabledDebuggerAdapters = listToAttrs (
    map (v: {
      name = "${v}-adapter";
      value = debuggers.${v}.dapAdapter;
    }) cfg.debugger.debuggers
  );

  # FIXME: this is broken, even using my fork 😔
  defaultDebuggers = [ ];
  # defaultDebuggers = ["vscode-js-debug-node"];
  debuggers = {
    vscode-js-debug-node = {
      package = pkgs.vscode-js-debug;
      dapAdapter = ''
        -- require("dap-vscode-js").setup({
        --   -- node_path = "${pkgs.nodejs_18}/bin/node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        --   -- debugger_path = "${enabledDebuggerPackages.vscode-js-debug-node}/src", -- Path to vscode-js-debug installation.
        --   debugger_cmd = { "${pkgs.nodejs_18}/bin/node", "${enabledDebuggerPackages.vscode-js-debug-node}/src/dapDebugServer.js" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        --   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
        --   -- log_file_path = "~/dap-log", -- Path for file logging
        --   -- log_file_level = true, -- Logging level for output to file. Set to false to disable file logging.
        --   -- log_console_level = vim.log.levels.DEBUG, -- Logging level for output to console. Set to false to disable console output.
        -- })

        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "''${port}",
          executable = {
            command = "${pkgs.nodejs_18}/bin/node ${enabledDebuggerPackages.vscode-js-debug-node}/src/dapDebugServer.js", -- As I'm using mason, this will be in the path
            args = { "''${port}" },
          }
        }
      '';

      dapConfig = ''
        dap.configurations["typescript"] = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Node",
            -- processId = require("dap.utils").pick_process,
            -- processId = getNodeProcesses,
            processId = function() return require("dap.utils").pick_process({ filter = "node " }) end,
            -- processId = require("dap.utils").pick_process({ filter = "node" }),
            cwd = "''${workspaceFolder}",
            -- port = 8123,
            -- port = "''${port}",
          },
        }
      '';
    };
  };

  defaultFormat = "prettier";
  formats = {
    prettier = {
      package = pkgs.nodePackages.prettier;
      formatterHandler = ''
        javascript = {
          function()
            local cwd = vim.fn.getcwd()
            local prettierExists = vim.fn.executable('prettier') == 1
            if prettierExists == true then
              prettierScript = "${cfg.format.package}/bin/prettier"
            else
              prettierScript = "prettier"
            end
            return {
              exe = prettierScript,
              args = {
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
              },
              stdin = true,
              try_node_modules = true,
            }
          end,
        },
        typescript = {
          function()
            local cwd = vim.fn.getcwd()
            local prettierExists = vim.fn.executable('prettier') == 1
            if prettierExists == true then
              prettierScript = "${cfg.format.package}/bin/prettier"
            else
              prettierScript = "prettier"
            end
            return {
              exe = prettierScript,
              args = {
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
              },
              stdin = true,
              try_node_modules = true,
            }
          end,
        },
        typescriptreact = {
          function()
            local cwd = vim.fn.getcwd()
            local prettierExists = vim.fn.executable('prettier') == 1
            if prettierExists == true then
              prettierScript = "${cfg.format.package}/bin/prettier"
            else
              prettierScript = "prettier"
            end
            return {
              exe = prettierScript,
              args = {
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
              },
              stdin = true,
              try_node_modules = true,
            }
          end,
        },
      '';
    };
  };
in
{
  options.vim.languages.typescript = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.languages.enableAll;
      description = "Typescript language support";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Typescript treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      tsPackage = nvim.types.mkGrammarOption pkgs "typescript";
      tsxPackage = nvim.types.mkGrammarOption pkgs "tsx";
      jsPackage = nvim.types.mkGrammarOption pkgs "javascript";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Typescript LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      servers = mkOption {
        description = "Typescript LSP servers to use";
        type = types.listOf (types.enum (attrNames servers));
        default = defaultServers;
      };
      packages = mkOption {
        description = "Typescript LSP server packages";
        type = types.listOf types.package;
        default = map (v: servers.${v}.package) cfg.lsp.servers;
      };
    };

    debugger = {
      enable = mkOption {
        description = "Enable Typescript Debugger support";
        type = types.bool;
        default = config.vim.languages.enableDebugger;
      };
      debuggers = mkOption {
        description = "Typescript LSP servers to use";
        type = types.listOf (types.enum (attrNames debuggers));
        default = defaultDebuggers;
      };
      packages = mkOption {
        description = "Typescript LSP server packages";
        type = types.listOf types.package;
        default = map (v: debuggers.${v}.package) cfg.debugger.debuggers;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Typescript formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Typescript formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Typescript formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };

    linting = {
      enable = mkOption {
        description = "Enable Typescript linter";
        type = types.bool;
        default = config.vim.languages.enableLinting;
      };
      linters = mkOption {
        description = "Typescript linters to use";
        type = with types; listOf str;
        default = [ "eslint" ];
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.luaConfigRC.nix = nvim.dag.entryAnywhere ''
        vim.api.nvim_create_autocmd(
          { "FileType" },
          {
            pattern = "ts",
            command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2]],
          }
        )

        vim.api.nvim_create_autocmd(
          { "FileType" },
          {
            pattern = "tsx",
            command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2]],
          }
        )

        vim.api.nvim_create_autocmd(
          { "FileType" },
          {
            pattern = "js",
            command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2]],
          }
        )

        vim.api.nvim_create_autocmd(
          { "FileType" },
          {
            pattern = "jsx",
            command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2]],
          }
        )
      '';
    }

    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [
        cfg.treesitter.tsPackage
        cfg.treesitter.tsxPackage
        cfg.treesitter.jsPackage
      ];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;

      vim.lsp.lspconfig.sources = enabledServerConfigs;
    })

    (mkIf cfg.debugger.enable {
      vim.debugger.enable = true;

      vim.startPlugins = [ "nvim-dap-vscode-js" ];

      vim.debugger.configs = enabledDebuggerConfigs;
      vim.debugger.adapters = enabledDebuggerAdapters;
    })

    (mkIf cfg.format.enable {
      vim.formatter.enable = true;
      vim.formatter.fileTypes.typescript = formats.${cfg.format.type}.formatterHandler;
    })

    (mkIf cfg.linting.enable {
      vim.linting.enable = true;
      vim.linting.fileTypes.typescript = "typescript = {${builtins.concatStringsSep "," cfg.linting.linters}},";
    })
  ]);
}
