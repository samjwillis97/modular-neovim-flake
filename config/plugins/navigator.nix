{ pkgs, ... }:
{
  extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
    name = "navigator";
    src = pkgs.fetchFromGitHub {
      owner = "dynamotn";
      repo = "Navigator.nvim";
      rev = "d43816089689ccffd23543bc02331e9a68f3ec2f";
      sha256 = "1j0q8snfpxq42yama42zk7vchb3gjvsnv8n1ala66dhr0am601ng";
    };
  })];

  extraConfigLua = ''
    require("Navigator").setup()
  '';
}
