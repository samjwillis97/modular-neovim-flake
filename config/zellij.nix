{ pkgs, inputs, lib, ...}:
{
  extraConfigLua = ''
local zellijPlugin = {}

local function nav(short_direction, direction, action)
  -- Use "move-focus" if action is nil.
  if not action then
    action = "move-focus"
  end

  if action ~= "move-focus" and action ~= "move-focus-or-tab" then
    error("invalid action: " .. action)
  end

  -- get window ID, try switching windows, and get ID again to see if it worked
  local cur_winnr = vim.fn.winnr()
  vim.api.nvim_command("wincmd " .. short_direction)
  local new_winnr = vim.fn.winnr()

  -- if the window ID didn't change, then we didn't switch
  if cur_winnr == new_winnr then
    local command = "${pkgs.zellij}/bin/zellij -s " .. os.getenv("ZELLIJ_SESSION_NAME") .. " action " .. action .. " " .. direction
    vim.fn.system(command)
    if vim.v.shell_error ~= 0 then
      error(command)
    end
  end
end

function zellijPlugin.up()
  nav("k", "up", nil)
end

function zellijPlugin.down()
  nav("j", "down", nil)
end

function zellijPlugin.right()
  nav("l", "right", nil)
end

function zellijPlugin.left()
  nav("h", "left", nil)
end

function zellijPlugin.up_tab()
  nav("k", "up", "move-focus-or-tab")
end

function zellijPlugin.down_tab()
  nav("j", "down", "move-focus-or-tab")
end

function zellijPlugin.right_tab()
  nav("l", "right", "move-focus-or-tab")
end

function zellijPlugin.left_tab()
  nav("h", "left", "move-focus-or-tab")
end

-- create our commands
vim.api.nvim_create_user_command("ZellijNavigateUp", zellijPlugin.up, {})
vim.api.nvim_create_user_command("ZellijNavigateDown", zellijPlugin.down, {})
vim.api.nvim_create_user_command("ZellijNavigateLeft", zellijPlugin.left, {})
vim.api.nvim_create_user_command("ZellijNavigateRight", zellijPlugin.right, {})

vim.api.nvim_create_user_command("ZellijNavigateUpTab", zellijPlugin.up_tab, {})
vim.api.nvim_create_user_command("ZellijNavigateDownTab", zellijPlugin.down_tab, {})
vim.api.nvim_create_user_command("ZellijNavigateLeftTab", zellijPlugin.left_tab, {})
vim.api.nvim_create_user_command("ZellijNavigateRightTab", zellijPlugin.right_tab, {})
  '';
}
