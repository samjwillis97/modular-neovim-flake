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

  # Use lz.n for lazy loading
  extraConfigLua = ''
    require("lz.n").load({
      {
        "actions-preview",
        keys = { "<leader>ca" },
        after = function()
          require("actions-preview").setup()
        end,
      },
    })
  '';

  keymaps = [
    {
      key = "<leader>ca";
      action = "<CMD>lua require('actions-preview').code_actions()<CR>";
      options.desc = "Code actions preview";
    }
  ];
}
