{ config, lib, ... }:
let
  cfg = config.custom.copilot.autocomplete;
in
{
  options.custom.copilot.autocomplete = {
    enable = lib.mkEnableOption "Copilot autocomplete integration with blink.cmp";
  };

  config = lib.mkIf cfg.enable {
    plugins.blink-copilot = {
      enable = true;
      lazyLoad.settings = {
        event = "DeferredUIEnter";
      };
    };

    plugins.blink-cmp.settings = {
      sources = {
        default = [
          "lsp"
          "path"
          "buffer"
          "copilot"
        ];

        providers = {
          copilot = {
            async = true;
            module = "blink-copilot";
            name = "copilot";
            score_offset = 100;
            opts = {
              max_completions = 3;
              max_attempts = 4;
              kind = "Copilot";
              debounce = 750;
              auto_refresh = {
                backward = true;
                forward = true;
              };
            };
          };
        };
      };
    };
  };
}
