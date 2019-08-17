{ # The git revision here corresponds to the nixpkgs-unstable channel, which at
  # the time of this writing has GHC 8.6.5 as the default compiler (matching the
  # one used by stack.yaml). Use https://howoldis.herokuapp.com/ to determine
  # the current rev.
  pkgs ? import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/002b853782e.tar.gz") {}
  # Which GHC compiler to use.
  # To determine the list of compilers available run:
  #   nix-env -f "<nixpkgs>" -qaP -A haskell.compiler
, compiler ? "default"
}:
let
  haskellPackages =
    if compiler == "default"
      then pkgs.haskellPackages
      else pkgs.haskell.packages.${compiler};
  fetchGitHubArchive = owner: repo: rev: builtins.fetchTarball "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
in
haskellPackages.extend (pkgs.haskell.lib.packageSourceOverrides {
  summoner = ./summoner-cli;
  summoner-tui = ./summoner-tui;
  relude = fetchGitHubArchive "kowainik" "relude" "55968311244690f5cc8b4484a37a63d988ea2ec4";
  tomland = fetchGitHubArchive "kowainik" "tomland" "8ef78e5fcfd7055b1db6402713d27a0aa42a82f8";
  shellmet = fetchGitHubArchive "kowainik" "shellmet" "36149eb0eb2b81916a93cdb92f3cb949d2eb9d23";
  optparse-applicative = builtins.fetchTarball "https://github.com/pcapriotti/optparse-applicative/archive/5478fc16cbd3384c19e17348a17991896c724a3c.tar.gz";
  parser-combinators = builtins.fetchTarball "https://github.com/mrkkrp/parser-combinators/archive/4262c00ef70cc30bfc56db0a10c37d88ad88fe1a.tar.gz";
})

#   modifier = drv: pkgs.haskell.lib.overrideCabal drv (attrs: {
#     buildTools = with haskellPackages; (attrs.buildTools or []) ++ [
#       cabal-install
#       ghcid
#       pkgs.gitAndTools.hub
#     ];
#   });
# }
