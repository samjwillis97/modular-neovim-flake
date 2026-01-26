{
  plugins.actions-preview = {
    enable = true;

    lazyLoad.settings = {
      keys = [
        {
          __unkeyed-1 = "<leader>ca";
          __unkeyed-2.__raw = ''
            function()
              require('actions-preview').code_actions()
            end
          '';
          desc = "Code actions preview";
        }
      ];
    };
  };
}
