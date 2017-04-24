{ mkDerivation, base, stdenv, xmonad, xmonad-contrib, xmonad-extras
}:
mkDerivation {
  pname = "xmonad-config";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base xmonad xmonad-contrib xmonad-extras
  ];
  license = stdenv.lib.licenses.unfree;
}
