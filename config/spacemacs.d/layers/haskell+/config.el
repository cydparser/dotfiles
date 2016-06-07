(setq haskell-enable-ghc-mod-support nil)

(configuration-layer/declare-layer 'haskell)
(defvar haskell+-ghc-args
  '("-fdefer-type-errors"
    "-ferror-spans"
    "-fno-warn-missing-signatures"
    "-fno-warn-partial-type-signatures"
    "-fno-warn-type-defaults")
  "GHC arguments to use with flycheck and GHCi")

(defvar haskell+-ghc-language-extensions
  '("NamedWildCards"
    "PartialTypeSignatures")
  "Language extensions to use with flycheck and GHCi")
