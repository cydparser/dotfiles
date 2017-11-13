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
  };
}
