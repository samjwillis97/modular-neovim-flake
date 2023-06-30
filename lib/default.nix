rec {
  mkNeovimConfiguration = { modules ? [ ], ... }@args:
    import ../modules (args // { modules = modules; });

  buildPkg = { pkgs, modules ? [ ], ... }:
    (mkNeovimConfiguration { inherit pkgs modules; });

  neovimBin = pkg: "${pkg}/bin/nvim";
}
