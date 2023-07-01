{ config, lib, pkgs, currentModules, ... }:
with lib;
with builtins;
let
  # TODO: Why this? - must be something to do with how options are declared that I am missing 😬
  cfgBuild = config.build;
  cfgBuilt = config.built;
  cfgVim = config.vim;

  inputsSubmodule = { ... }: {
    options.src = mkOption {
      description = "The plugin source";
      type = types.package;
    };
  };
in {
  options = {
    build = {
      viAlias = mkOption {
        description = "Enable vi alias";
        type = types.bool;
        default = true;
      };

      vimAlias = mkOption {
        description = "Enable vim alias";
        type = types.bool;
        default = true;
      };

      rawPlugins = mkOption {
        type = with types; attrsOf (submodule inputsSubmodule);
        default = { };
      };

      package = mkOption {
        description = "Neovim to use for neovim-flake";
        type = types.package;
        default = pkgs.neovim-unwrapped;
      };
    };

    built = {
      configRC = mkOption {
        description = "The final built config";
        type = types.lines;
        readOnly = true;
      };

      startPlugins = mkOption {
        description = "The final built start plugins";
        type = with types; listOf package;
        readOnly = true;
      };

      optPlugins = mkOption {
        description = "The final built opt plugins";
        type = with types; listOf package;
        readOnly = true;
      };

      package = mkOption {
        description = "The final wrapped and configured neovim package";
        type = types.package;
        readOnly = true;
      };
    };
  };

  config = let
    buildPlug = name:
      # TODO: Understand :)
      pkgs.vimUtils.buildVimPluginFrom2Nix rec {
        pname = name;
        version = "master";
        src = assert asserts.assertMsg (name != "nvim-treesitter")
          "Use buildTreesitterPlug for building nvim-treesitter";
          cfgBuild.rawPlugins.${pname}.src;
      };

    treeSitterPlug = pkgs.vimPlugins.nvim-treesitter.withPlugins
      (_: config.vim.treesitter.grammars);

    buildConfigPlugins = plugins:
      map (plug:
        (if isString plug then
          (if (plug == "nvim-treesitter") then
            treeSitterPlug
          else
            buildPlug plug)
        else
          plug)) (filter (f: f != null) plugins);

    normalizedPlugins = cfgBuilt.startPlugins ++ (map (plugin: {
      inherit plugin;
      optional = true;
    }) cfgBuilt.optPlugins);

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit (cfgBuild) viAlias vimAlias;
      plugins = normalizedPlugins;
      customRC = cfgBuilt.configRC;
    };
  in {

    built = {
      # This creates a sectioned up config
      configRC = let
        mkSection = r: ''
          " SECTION: ${r.name}
          ${r.data}
        '';
        mapResult = r: (concatStringsSep "\n" (map mkSection r));
        vimConfig = nvim.dag.resolveDag {
          name = "vim config script";
          dag = cfgVim.configRC;
          inherit mapResult;
        };
      in vimConfig;

      startPlugins = buildConfigPlugins cfgVim.startPlugins;
      optPlugins = buildConfigPlugins cfgVim.optPlugins;

      # TODO: Really understand this whole thing properly - Seems to basically just keep 
      # overriding/overwriting attributes and creates the neovim package that was declared
      # really need to understand the _module and check though
      package = (pkgs.wrapNeovimUnstable cfgBuild.package
        (neovimConfig // { wrapRc = true; })).overrideAttrs (oldAttrs: {
          passthru = oldAttrs // {
            extendConfiguration = { modules ? [ ]
              , pkgs ? config._module.args.pkgs, lib ? pkgs.lib
              , extraSpecialArgs ? { }, check ? config._module.args.check, }:
              import ../../modules {
                modules = currentModules ++ modules;
                extraSpecialArgs = config._module.specialArgs
                  // extraSpecialArgs;
                inherit pkgs lib;
              };
          };
          meta = oldAttrs.meta // { module = { inherit config options; }; };
        });
    };
  };
}
