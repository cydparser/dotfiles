with import <nixpkgs> {}; let
  drv = haskellPackages.callPackage ./default.nix {};
in
  if pkgs.lib.inNixShell
  then drv.env
  else drv
