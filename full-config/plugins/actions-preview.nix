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
    require("actions-preview").setup()
  '';

  keymaps = [
    {
      key = "<leader>ca";
      action = "<CMD>lua require('actions-preview').code_actions()<CR>";
    }
  ];
}
