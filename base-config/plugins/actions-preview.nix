{ pkgs, ... }:
let
  actions-preview = pkgs.vimUtils.buildVimPlugin {
    name = "actions-preview";
    src = pkgs.fetchFromGitHub {
      owner = "aznhe21";
      repo = "actions-preview.nvim";
      rev = "9f52a01c374318e91337697ebed51c6fae57f8a4";
      sha256 = "0gr3gwmb2mcqphybx1yxsbpdlvvjpchzwich3a9wnz5mrjzyr24m";
    };
  };
in
{
  extraPlugins = [
    actions-preview
  ];

  extraConfigLua = ''
    -- Lazy load actions-preview
    local loaded = false
    local function load_actions_preview()
      if not loaded then
        require("actions-preview").setup()
        loaded = true
      end
    end

    -- Set up lazy-loaded keymap
    vim.keymap.set("n", "<leader>ca", function()
      load_actions_preview()
      require('actions-preview').code_actions()
    end, { desc = "Code actions preview" })
  '';
}
