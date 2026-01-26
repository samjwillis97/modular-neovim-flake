{
  plugins.colorizer = {
    enable = true;

    # Load only for filetypes that commonly use color codes
    lazyLoad.settings = {
      ft = [
        "css"
        "scss"
        "sass"
        "html"
        "javascript"
        "typescript"
        "javascriptreact"
        "typescriptreact"
        "lua"
        "vim"
        "nix"
      ];
    };
  };
}
