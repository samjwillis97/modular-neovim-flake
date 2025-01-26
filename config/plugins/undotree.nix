{
  opts = {
    undofile = true;
    undodir.__raw = ''os.getenv("HOME") .. "/.vim/undodir/"'';
  };

  plugins.undotree = {
    enable = true;
  };
}
