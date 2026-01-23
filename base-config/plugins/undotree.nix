{
  opts = {
    undofile = true;
    undodir.__raw = ''os.getenv("HOME") .. "/.vim/undodir/"'';
  };

  plugins.undotree = {
    enable = true;

    # Lazy load on UndotreeToggle command
    lazyLoad.settings = {
      cmd = "UndotreeToggle";
    };
  };
}
