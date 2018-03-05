self: super: {
  texlive-overlay = super.texlive.combine {
    inherit (self.texlive) scheme-basic
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
