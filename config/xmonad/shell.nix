{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
  drv = pkgs.haskellPackages.callPackage ./default.nix {};
in
  if pkgs.lib.inNixShell then drv.env else drv
