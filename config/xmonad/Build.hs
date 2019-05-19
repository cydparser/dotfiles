#!/usr/bin/env nix-shell
#!nix-shell -i runhaskell
#!nix-shell -p 'haskellPackages.ghcWithPackages (pkgs: with pkgs; [shake])'

{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

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
    fromStdout <$> cmd "nix" ["eval", "((import <nixpkgs> {}).lib.version)"] :: Action String

  action $ do
    _ <- getNixpkgsVersion NixpkgsVersion
    need ["default.nix", "shell.nix"]
    cmd "nix-shell" ["--run", "cabal v1-configure"] :: Action ()

  "default.nix" %> \f -> do
    need ["xmonad-config.cabal"]
    Stdout nix <- cmd "cabal2nix ."
    writeFileChanged f nix

data NixpkgsVersion = NixpkgsVersion
  deriving (Binary, Eq, Generic, Hashable, NFData, Show, Typeable)

type instance RuleResult NixpkgsVersion = String
