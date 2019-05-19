{ mkDerivation, base, shake, stdenv, xmonad, xmonad-contrib
, xmonad-extras
}:
mkDerivation {
  pname = "xmonad-config";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base shake xmonad xmonad-contrib xmonad-extras
  ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
