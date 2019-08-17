let
  haskellPackages = import ./. {};
in 
haskellPackages.shellFor {
  withHoogle = false;
  packages = p: 
    [ p.summoner 
      p.summoner-tui 
    ];
  buildInputs = with haskellPackages; 
    [ cabal-install 
      ghcid 
      # pkgs.gitAndTools.hub
    ];
}
