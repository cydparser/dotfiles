self: super:
let
  lib = super.lib;
  tl = super.texlive;
in {
  texlive-overlay = tl.combine {
    inherit (tl) scheme-basic
      collection-binextra
      collection-fontsrecommended
      collection-latexrecommended
      collection-luatex
      csquotes;
    extraName = "overlay";
    pkgFilter = pkg:
      lib.elem pkg.tlType [ "bin" "doc" "run" ] || pkg.pname == "core";
  };
}
