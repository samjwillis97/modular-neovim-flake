{
  keymaps = [
    {
      key = "<leader>dvt";
      action = "<CMD>CodeDiff<CR>";
      options.desc = "Toggle CodeDiff Explorer";
    }
    {
      key = "<leader>dvo";
      action = "<CMD>CodeDiff main...<CR>";
      options.desc = "PR-like diff against main";
    }
    {
      key = "<leader>dvf";
      action = "<CMD>CodeDiff file HEAD<CR>";
      options.desc = "Diff file against HEAD";
    }
    {
      key = "<leader>dvh";
      action = "<CMD>CodeDiff history<CR>";
      options.desc = "CodeDiff file history";
    }
    {
      key = "<leader>dvb";
      action = "<CMD>CodeDiffBranchSelect<CR>";
      options.desc = "CodeDiff against branch";
    }
    {
      key = "<leader>dvc";
      action = "<CMD>CodeDiffClose<CR>";
      options.desc = "Close CodeDiff";
    }
  ];

  plugins.codediff = {
    enable = true;

    # Lazy load on CodeDiff commands and keymaps
    lazyLoad.settings = {
      cmd = [
        "CodeDiff"
      ];
      keys = [
        "<leader>dvt"
        "<leader>dvo"
        "<leader>dvf"
        "<leader>dvh"
        "<leader>dvb"
        "<leader>dvc"
      ];
    };

    settings = {
      diff = {
        layout = "side-by-side";
        disable_inlay_hints = true;
        jump_to_first_change = true;
        compute_moves = true;
      };

      explorer = {
        position = "left";
        width = 40;
        indent_markers = true;
        view_mode = "tree";
        flatten_dirs = true;
      };

      history = {
        position = "bottom";
        height = 15;
      };
    };
  };

  extraConfigLuaPost = ''
    -- Create a custom picker using the git_branches picker
    local function custom_git_branches_picker()
      Snacks.picker.git_branches({
        confirm = function(picker, item)
          picker:close()
          vim.cmd('CodeDiff ' .. item.branch)
        end,
      })
    end

    -- Create a command to call the custom picker
    vim.api.nvim_create_user_command('CodeDiffBranchSelect', custom_git_branches_picker, {})

    -- Close any open CodeDiff tab, works from any tab
    vim.api.nvim_create_user_command('CodeDiffClose', function()
      local lifecycle = require('codediff.ui.lifecycle')
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        if lifecycle.get_session(tab) then
          if not lifecycle.confirm_close_with_unsaved(tab) then
            return
          end
          if #vim.api.nvim_list_tabpages() == 1 then
            lifecycle.cleanup_for_quit(tab)
            vim.cmd('qall')
          else
            local tab_nr = vim.api.nvim_tabpage_get_number(tab)
            vim.cmd(tab_nr .. 'tabclose')
          end
          return
        end
      end
      vim.notify('No CodeDiff view open', vim.log.levels.INFO)
    end, {})
  '';
}
