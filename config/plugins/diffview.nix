{
  keymaps = [
    {
      key = "<leader>dvt";
      action = "<CMD>DiffviewToggle<CR>";
      options.desc = "Toggle Diffview";
    }
    {
      key = "<leader>dvo";
      action = "<CMD>DiffviewOpen<CR>";
      options.desc = "Open Diffview";
    }
    {
      key = "<leader>dvc";
      action = "<CMD>DiffviewClose<CR>";
      options.desc = "Close Diffview";
    }
    {
      key = "<leader>dvb";
      action = "<CMD>DiffviewBranchSelect<CR>";
      options.desc = "Open Diffview to branch";
    }
  ];

  plugins.diffview = {
    enable = true;

    view = {
      default = {
        winbarInfo = true;
      };

      mergeTool = {
        winbarInfo = true;
      };
    };
  };

  extraConfigLuaPost = ''
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local builtin = require('telescope.builtin')
    local diffview = require('diffview')

    -- Define a custom action to print the branch name
    local function open_diff_on_branch_name(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      actions.close(prompt_bufnr)
      vim.cmd('DiffviewOpen ' .. selection.value)
    end

    -- Create a custom picker using the git_branches picker
    local function custom_git_branches_picker()
      builtin.git_branches({
        attach_mappings = function(_, map)
          map('i', '<CR>', open_diff_on_branch_name)
          map('n', '<CR>', open_diff_on_branch_name)
          return true
        end
      })
    end

    -- Create a command to call the custom picker
    vim.api.nvim_create_user_command('DiffviewBranchSelect', custom_git_branches_picker, {})
  '';
}
