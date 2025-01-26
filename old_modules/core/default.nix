{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim;

  wrapLuaConfig = luaConfig: ''
    lua << EOF
    ${luaConfig}
    EOF
  '';

  mkMappingOption =
    it:
    mkOption (
      {
        default = { };
        type = with types; attrsOf (nullOr str);
      }
      // it
    );
in
{
  options.vim = {
    configRC = mkOption {
      description = "vimrc contents";
      type = nvim.types.dagOf types.lines;
      default = { };
    };

    luaConfigRC = mkOption {
      description = "vim lua config";
      type = nvim.types.dagOf types.lines;
      default = { };
    };

    startPlugins = nvim.types.pluginsOpt {
      rawPlugins = config.build.rawPlugins;
      default = [ ];
      description = "List of plugins to startup.";
    };

    optPlugins = nvim.types.pluginsOpt {
      rawPlugins = config.build.rawPlugins;
      default = [ ];
      description = "List of plugins to optionally load";
    };

    globals = mkOption {
      default = { };
      description = "Set containing global variable values";
      type = types.attrs;
    };

    nnoremap = mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    inoremap = mkMappingOption { description = "Defines 'Insert and Replace mode' mappings"; };

    vnoremap = mkMappingOption { description = "Defines 'Visual and Select mode' mappings"; };

    xnoremap = mkMappingOption { description = "Defines 'Visual mode' mappings"; };

    snoremap = mkMappingOption { description = "Defines 'Select mode' mappings"; };

    cnoremap = mkMappingOption { description = "Defines 'Command-line mode' mappings"; };

    onoremap = mkMappingOption { description = "Defines 'Operator pending mode' mappings"; };

    tnoremap = mkMappingOption { description = "Defines 'Terminal mode' mappings"; };

    nmap = mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    imap = mkMappingOption { description = "Defines 'Insert and Replace mode' mappings"; };

    vmap = mkMappingOption { description = "Defines 'Visual and Select mode' mappings"; };

    xmap = mkMappingOption { description = "Defines 'Visual mode' mappings"; };

    smap = mkMappingOption { description = "Defines 'Select mode' mappings"; };

    cmap = mkMappingOption { description = "Defines 'Command-line mode' mappings"; };

    omap = mkMappingOption { description = "Defines 'Operator pending mode' mappings"; };

    tmap = mkMappingOption { description = "Defines 'Terminal mode' mappings"; };

    imapexpr = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings that are expressions";
    };
  };

  # TODO: Look into this properly, make sure it makes sense to me for later on
  config =
    let
      mkVimBool = val: if val then "true" else "false";
      valToVim =
        val:
        if (isInt val) then
          (builtins.toString val)
        else
          (if (isBool val) then (mkVimBool val) else (toJSON val));

      filterNonNull = mappings: filterAttrs (name: value: value != null) mappings;
      globalsScript = lib.attrsets.mapAttrsToList (name: value: "let g:${name}=${valToVim value}") (
        filterNonNull cfg.globals
      );

      matchCtrl = it: match "Ctrl-(.)(.*)" it;
      mapKeyBinding =
        it:
        let
          groups = matchCtrl it;
        in
        if groups == null then it else "<C-${toUpper (head groups)}>${head (tail groups)}";

      mapVimBinding =
        prefix: remap: expr: silent: mappings:
        lib.attrsets.mapAttrsToList (name: value: ''
          vim.api.nvim_set_keymap("${prefix}", "${mapKeyBinding name}", "${value}", { 
            expr = ${if expr then "true" else "false"},
            silent = ${if silent then "true" else "false"},
            noremap = ${if remap then "true" else "false"},
          }
          )'') (filterNonNull mappings);

      nmap = mapVimBinding "n" false false false config.vim.nmap;
      imap = mapVimBinding "i" false false false config.vim.imap;
      vmap = mapVimBinding "v" false false false config.vim.vmap;
      xmap = mapVimBinding "x" false false false config.vim.xmap;
      smap = mapVimBinding "s" false false false config.vim.smap;
      cmap = mapVimBinding "c" false false false config.vim.cmap;
      omap = mapVimBinding "o" false false false config.vim.omap;
      tmap = mapVimBinding "t" false false false config.vim.tmap;

      nnoremap = mapVimBinding "n" true false false config.vim.nnoremap;
      inoremap = mapVimBinding "i" true false false config.vim.inoremap;
      vnoremap = mapVimBinding "v" true false false config.vim.vnoremap;
      xnoremap = mapVimBinding "x" true false false config.vim.xnoremap;
      snoremap = mapVimBinding "s" true false false config.vim.snoremap;
      cnoremap = mapVimBinding "c" true false false config.vim.cnoremap;
      onoremap = mapVimBinding "o" true false false config.vim.onoremap;
      tnoremap = mapVimBinding "t" true false false config.vim.tnoremap;

      imapexpr = mapVimBinding "i" false true true config.vim.imap;
    in
    {
      vim = {
        configRC = {
          globalsScript = nvim.dag.entryAnywhere (concatStringsSep "\n" globalsScript);

          luaScript =
            let
              mkSection = r: ''
                -- SECTION: ${r.name}
                ${r.data}
              '';
              mapResult = r: (wrapLuaConfig (concatStringsSep "\n" (map mkSection r)));
              luaConfig = nvim.dag.resolveDag {
                name = "lua config script";
                dag = cfg.luaConfigRC;
                inherit mapResult;
              };
            in
            nvim.dag.entryAfter [ "globalsScript" ] luaConfig;

          mappings =
            let
              maps = [
                nmap
                imap
                vmap
                xmap
                smap
                cmap
                omap
                tmap
                nnoremap
                inoremap
                vnoremap
                xnoremap
                snoremap
                cnoremap
                onoremap
                tnoremap
                imapexpr
              ];
              mapConfig = (wrapLuaConfig (concatStringsSep "\n" (map (v: concatStringsSep "\n" v) maps)));
            in
            nvim.dag.entryAfter [ "luaScript" ] mapConfig;
        };
      };
    };
}
