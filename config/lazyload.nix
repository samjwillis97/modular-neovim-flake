{
  plugins = {
    lz-n = {
      enable = true;
      autoLoad = true;
    };

    render-markdown.lazyLoad.settings.ft = ["markdown" "Avante"];

    gitsigns.lazyLoad.settings.event = [ "DeferredUIEnter" ];
    avante.lazyLoad.settings.event = [ "DeferredUIEnter" ];

    telescope.lazyLoad.settings.cmd = "Telescope";

    lazyLoad.settings.cmd = [ "Yazi" ];
  };
}
