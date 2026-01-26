{ pkgs, ... }:
let
  cursortab = pkgs.vimUtils.buildVimPlugin {
    name = "cursortab";
    version = "2026-01-26";
    src = pkgs.fetchFromGitHub {
      owner = "samjwillis97";
      repo = "cursortab.nvim";
      rev = "d8645053a799d777b985eef2517fd9593e4b5fb8";
      sha256 = "YKuvYw65+k4N1pIm8EEck5lvtfDOnQohOcgHAhsSJxk=";
    };

    # Patch the Go server to use XDG_STATE_HOME for logs, socket, and pid
    postPatch = ''
      # Add getStateDir function before setupLogger
      sed -i '/^\/\/ Setup logger to log to a file/i\
// getStateDir returns the XDG_STATE_HOME directory for cursortab\
func getStateDir() string {\
\tstateDir := os.Getenv("XDG_STATE_HOME")\
\tif stateDir == "" {\
\t\thome := os.Getenv("HOME")\
\t\tif home == "" {\
\t\t\thome = "/tmp"\
\t\t}\
\t\tstateDir = filepath.Join(home, ".local", "state")\
\t}\
\tcursortabDir := filepath.Join(stateDir, "nvim", "cursortab")\
\tos.MkdirAll(cursortabDir, 0755)\
\treturn cursortabDir\
}\
' server/main.go

      # Replace setupLogger function
      substituteInPlace server/main.go \
        --replace-fail 'func setupLogger(logLevel string) *logger.LimitedLogger {
	execPath, err := os.Executable()
	if err != nil {
		logger.Fatal("error getting executable path: %v", err)
	}
	execDir := filepath.Dir(execPath)
	logPath := filepath.Join(execDir, "cursortab.log")' \
'func setupLogger(logLevel string) *logger.LimitedLogger {
	stateDir := getStateDir()
	logPath := filepath.Join(stateDir, "cursortab.log")'

      # Replace getSocketPath function  
      substituteInPlace server/main.go \
        --replace-fail 'func getSocketPath() string {
	execPath, err := os.Executable()
	if err != nil {
		logger.Fatal("error getting executable path: %v", err)
	}
	execDir := filepath.Dir(execPath)
	return filepath.Join(execDir, "cursortab.sock")
}' \
'func getSocketPath() string {
	return filepath.Join(getStateDir(), "cursortab.sock")
}'

      # Replace getPidPath function
      substituteInPlace server/main.go \
        --replace-fail 'func getPidPath() string {
	execPath, err := os.Executable()
	if err != nil {
		logger.Fatal("error getting executable path: %v", err)
	}
	execDir := filepath.Dir(execPath)
	return filepath.Join(execDir, "cursortab.pid")
}' \
'func getPidPath() string {
	return filepath.Join(getStateDir(), "cursortab.pid")
}'
    '';

    # Build the Go server component
    buildPhase = ''
      export HOME=$TMPDIR
      cd server
      ${pkgs.go}/bin/go build -o cursortab .
      cd ..
    '';

    postInstall = ''
      mkdir -p $out/server
      cp server/cursortab $out/server/
    '';
  };
in
{
  extraPlugins = [
    cursortab
  ];

  extraConfigLua = ''
    require("cursortab").setup({
      provider = {
        type = "sweep",
        url = "http://127.0.0.1:8000",
        model = "sweep-next-edit-1.5b",
      }
    })

    -- Override log path functions to use XDG_STATE_HOME/nvim/cursortab
    local function get_log_path()
      local state_dir = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
      local log_dir = state_dir .. "/nvim/cursortab"
      vim.fn.mkdir(log_dir, "p")
      return log_dir .. "/cursortab.log"
    end

    -- Override show_log function
    local cursortab = require("cursortab")
    cursortab.show_log = function()
      local log_path = get_log_path()
      if vim.fn.filereadable(log_path) == 0 then
        vim.notify("Log file not found: " .. log_path, vim.log.levels.WARN)
        return
      end
      local lines = vim.fn.readfile(log_path)
      require("cursortab.ui").create_scratch_window("Cursortab Log", lines, {
        filetype = "log",
        move_to_end = true,
        size_mode = "fullscreen",
      })
      vim.notify("Showing cursortab log", vim.log.levels.INFO)
    end

    -- Override clear_log function
    cursortab.clear_log = function()
      local log_path = get_log_path()
      if vim.fn.filereadable(log_path) == 0 then
        vim.notify("Log file not found: " .. log_path, vim.log.levels.WARN)
        return
      end
      vim.fn.writefile({}, log_path)
      vim.notify("Cursortab log cleared", vim.log.levels.INFO)
    end

    -- Override show_status function to check correct paths
    cursortab.show_status = function()
      local state_dir = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
      local cursortab_dir = state_dir .. "/nvim/cursortab"
      local socket_path = cursortab_dir .. "/cursortab.sock"
      local pid_path = cursortab_dir .. "/cursortab.pid"
      
      local plugin_enabled = vim.g.cursortab_enabled ~= false
      local socket_exists = vim.fn.filereadable(socket_path) == 1 or vim.fn.isdirectory(socket_path) == 1
      local pid_exists = vim.fn.filereadable(pid_path) == 1
      
      local pid = nil
      local process_running = false
      if pid_exists then
        local pid_content = vim.fn.readfile(pid_path)
        if #pid_content > 0 then
          pid = tonumber(pid_content[1])
          if pid then
            -- Check if process is running using kill -0
            local result = vim.fn.system("kill -0 " .. pid .. " 2>/dev/null")
            process_running = vim.v.shell_error == 0
          end
        end
      end
      
      local client_connected = require("cursortab.client").is_connected()
      local channel_id = require("cursortab.client").get_channel_id()
      
      local lines = {
        " ___/_ _________ ___  ____/ /____ _/ / ",
        "/ /__/ // / __(_-</ _ \\/ __/ __/ _ `/ _ \\",
        "\\___/\\_,_/_/ /___/\\___/_/  \\__/\\_,_/_.__/",
        "",
        "Plugin State:",
        "  • Enabled: " .. (plugin_enabled and "✓ Yes" or "✗ No"),
        "",
        "Daemon Status:",
        "  • Socket exists: " .. (socket_exists and "✓ Yes" or "✗ No"),
        "  • PID file exists: " .. (pid_exists and "✓ Yes" or "✗ No"),
        "  • Process running: " .. (process_running and "✓ Yes" or "✗ No"),
      }
      
      if pid then
        table.insert(lines, "  • PID: " .. pid)
      end
      
      table.insert(lines, "")
      table.insert(lines, "Client Connection:")
      table.insert(lines, "  • Connected: " .. (client_connected and "✓ Yes" or "✗ No"))
      
      if channel_id then
        table.insert(lines, "  • Channel ID: " .. channel_id)
      end
      
      require("cursortab.ui").create_scratch_window("Cursortab Status", lines, {
        filetype = "cursortab-status",
        size_mode = "compact",
      })
    end
  '';
}
