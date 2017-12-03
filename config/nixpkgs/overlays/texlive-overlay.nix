self: super:
let
  lib = super.lib;
  tl = super.texlive;
in {
  texlive-overlay = tl.combine {
    inherit (tl) scheme-basic
      collection-binextra
      collection-fontsextra
      collection-fontsrecommended
      collection-fontutils
      collection-latexrecommended
      collection-luatex
      csquotes
      enumitem
      etoolbox
      fontaxes;
    extraName = "overlay";
  };
}
