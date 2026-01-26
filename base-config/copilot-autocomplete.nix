{ config, lib, ... }:
let
  cfg = config.custom.copilot.autocomplete;
in
{
  options.custom.copilot.autocomplete = {
    enable = lib.mkEnableOption "Copilot autocomplete integration with blink.cmp";
  };

  config = lib.mkIf cfg.enable {
    # Explicitly configure copilot.lua to prevent nixvim from loading it eagerly
    plugins.copilot-lua = {
      enable = true;
      lazyLoad.settings = {
        event = "InsertEnter";
      };

      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
    };

    plugins.blink-copilot = {
      enable = true;
      lazyLoad.settings = {
        event = "InsertEnter";
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
