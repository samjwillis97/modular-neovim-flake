{
  # Enable lz.n lazy loading backend
  plugins.lz-n.enable = true;

  imports = [
    ./transparent.nix
    # ./nui.nix
    ./web-devicons.nix
    # ./nvim-tree.nix
    ./treesitter-context.nix
    ./gitsigns.nix
    ./fugitive.nix
    ./autopairs.nix
    ./colorizer.nix
    ./ts-comments.nix
    ./conform.nix
    ./telescope.nix
    ./tmux-navigator.nix
    ./lualine.nix
    ./indent-blankline.nix
    ./nvim-ufo.nix
    ./undotree.nix
    ./surround.nix
    ./which-key.nix
    ./lastplace.nix
    ./actions-preview.nix
    ./neotest.nix
    ./snacks.nix
  ];
}
