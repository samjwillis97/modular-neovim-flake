{ pkgs, ... }:
let
  ToggleTreeKey = "<C-n>";

  configurableSelectLayout =
    {
      width ? 0.5,
      height ? 0.4,
    }:
    {
      hidden = [ "preview" ];
      layout = {
        inherit height width;
        backdrop = false;
        min_width = 40;
        max_width = 100;
        min_height = 2;
        box = "vertical";
        border = true;
        title = "{title}";
        title_pos = "center";
        __unkeyed-1 = {
          win = "input";
          height = 1;
          border = "bottom";
        };
        __unkeyed-2 = {
          win = "list";
          border = "none";
        };
        __unkeyed-3 = {
          win = "preview";
          title = "{preview}";
          height = 0.4;
          border = "top";
        };
      };
    };
in
{
  extraPackages = with pkgs; [
    fd
    ripgrep
  ];

  keymaps = [
    {
      key = ToggleTreeKey;
      action = "<CMD>lua Snacks.explorer.open()<CR>";
      options.desc = "Toggle file explorer";
    }
    {
      key = ",n";
      action = "<CMD>lua Snacks.explorer.open()<CR>";
      options.desc = "Toggle file explorer";
    }
    {
      key = "<leader>ff";
      action = "<CMD>lua Snacks.picker.files()<CR>";
      options.desc = "Open file search";
    }
    {
      key = "<leader>sf";
      action = "<CMD>lua Snacks.picker.git_grep()<CR>";
      options.desc = "Open grep over git files";
    }
    {
      key = "<leader>sw";
      action = "<CMD>lua Snacks.picker.grep_word()<CR>";
      options.desc = "Open grep for word under cursor";
    }
    {
      key = "gd";
      action = "<CMD>lua Snacks.picker.lsp_definitions()<CR>";
      options.desc = "Go to definition";
    }
    {
      key = "gr";
      action = "<CMD>lua Snacks.picker.lsp_references()<CR>";
      options.desc = "Find references";
    }
    {
      key = "gi";
      action = "<CMD>lua Snacks.picker.lsp_implementations()<CR>";
      options.desc = "Find implementations";
    }
  ];

  plugins.snacks = {
    enable = true;

    settings = {
      explorer = { };

      notifier = {
        enabled = true;
        top_down = false;
      };

      picker = {
        sources = {
          files = { };

          git_grep = { };

          grep_word = { };

          lsp_definitions = { };

          lsp_references = { };

          lsp_implementations = { };

          explorer = {
            auto_close = true;
            layout = configurableSelectLayout ({
              height = 0.8;
              width = 0.35;
            });
            win = {
              list = {
                keys = {
                  "<C-n>" = "cancel";
                  "h" = "explorer_close";
                  "o" = "confirm";
                  "O" = "explorer_open";
                };
              };
            };
          };
        };
      };
    };

    luaConfig.post = ''
      ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
              p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                  value.kind == "end" and 100 or value.percentage or 100,
                  value.title or "",
                  value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
              }
              break
            end
          end

          local msg = {} ---@type string[]
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    '';
  };
}
