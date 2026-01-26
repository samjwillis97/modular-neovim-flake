{ pkgs, ... }:
let
  namu = pkgs.vimUtils.buildVimPlugin {
    name = "namu";
    src = pkgs.fetchFromGitHub {
      owner = "bassamsdata";
      repo = "namu.nvim";
      rev = "fb13c050f3f4f812ca954caf60da48afdd274e1d";
      sha256 = "h7BVd9B6wpvC4ZmHhCDFK+60hZOMZpImQaRF5vHi61U=";
    };
  };
in
{
  extraPlugins = [
    namu
  ];

  # Use lz.n for lazy loading
  extraConfigLua = ''
    require("lz.n").load({
      {
        "namu",
        keys = { "<leader><leader>" },
        after = function()
          require("namu").setup()
        end,
      },
    })
  '';

  keymaps = [
    {
      key = "<leader><leader>";
      action = "<CMD>Namu symbols<CR>";
      options.desc = "Jump to LSP Symbols";
    }
  ];
}
