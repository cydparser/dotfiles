#!/usr/bin/env nix-shell
#!nix-shell -i runhaskell
#!nix-shell -p 'haskellPackages.ghcWithPackages (pkgs: with pkgs; [shake])'

{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
-- TODO: Use shake-0.16
-- {-# LANGUAGE TypeFamilies #-}

module Main (main) where

import Development.Shake
import Development.Shake.Classes
import GHC.Generics

main :: IO ()
main = shakeArgs shakeOptions $ do
  "clean" ~> do
    buildDir <- shakeFiles <$> getShakeOptions
    removeFilesAfter buildDir ["//*"]

  getNixpkgsVersion <- addOracle $ \NixpkgsVersion ->
    fromStdout <$> cmd "nix-instantiate"
      ["--eval", "-E", "(import <nixpkgs> {}).lib.nixpkgsVersion"] :: Action String

  action $ do
    _ <- getNixpkgsVersion NixpkgsVersion
    need ["default.nix", "shell.nix"]
    cmd "nix-shell" ["--run", "cabal configure"] :: Action ()

  "default.nix" %> \f -> do
    need ["package.yaml"]
    cmd "hpack" :: Action ()
    Stdout nix <- cmd "cabal2nix ."
    writeFileChanged f nix

data NixpkgsVersion = NixpkgsVersion
  deriving (Binary, Eq, Generic, Hashable, NFData, Show, Typeable)

-- type instance RuleResult NixpkgsVersion = String
