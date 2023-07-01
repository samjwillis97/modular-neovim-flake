{ rawPlugins, ... }: rec {
  mkNeovimConfiguration = { modules ? [ ], ... }@args:
    import ../modules (args // {
      modules = [{ config.build.rawPlugins = rawPlugins; }] ++ modules;
    });

  buildPkg = pkgs: modules: (mkNeovimConfiguration { inherit pkgs modules; });

  neovimBin = pkg: "${pkg}/bin/nvim";
}
