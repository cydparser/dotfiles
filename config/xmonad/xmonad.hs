{-# OPTIONS_GHC -Wno-missing-signatures #-}

module Main (main) where

import           System.Exit
import           XMonad
import           XMonad.Actions.UpdatePointer
import           XMonad.Config.Desktop
import           XMonad.Hooks.ManageDocks
import           XMonad.Layout.NoBorders (noBorders)
import           XMonad.Prompt
import           XMonad.Prompt.ConfirmPrompt
import qualified XMonad.StackSet as W
import           XMonad.Util.EZConfig

main :: IO ()
main =
 xmonad $ desktopConfig
    { focusedBorderColor = "#AAAAAA"
    , normalBorderColor = "black"
    , layoutHook = desktopLayoutModifiers layouts
    , logHook = updatePointer (0.5, 0.5) (0, 0) <+> logHook desktopConfig
    , manageHook = manageDocks <+> manageHook desktopConfig
    , modMask = mod4Mask -- windows key
    , terminal = term
    } `removeKeysP` unbindings `additionalKeysP` bindings

term = "termite"

layouts =
  tiled ||| Mirror tiled ||| noBorders Full
  where
    tiled = Tall
      { tallNMaster        = 1
      , tallRatioIncrement = 4/100
      , tallRatio          = 2/3
      }

unbindings =
  [ "M-j"
  , "M-S-j"
  , "M-S-k"
  , "M-p"
  , "M-S-q"
  ]

bindings =
  [ ("M-k",        kill)
  , ("M-S-o",      windows W.focusUp)
  , ("M-o",        windows W.focusDown)
  , ("M-q",        confirmPrompt promptConfig "quit XMonad" (io exitSuccess))
  , ("M-r",        spawn "xmonad --recompile && xmonad --restart")
  , ("M-t",        spawn term)
  , ("M-x",        spawn "dmenu_run -p '>>' -fn 'xft:inconsolata:size=16'")
  , ("M-<Down>",   withFocused (windows . W.sink))
  , ("M-<Left>",   sendMessage Shrink)
  , ("M-<Right>",  sendMessage Expand)
  , ("M-S-/",      spawn "xprop WM_CLASS WM_NAME WM_WINDOW_ROLE | xmessage -timeout 15 -file -")
  ]
  where
    promptConfig = def
      { position          = Top
      , alwaysHighlight   = True
      , height            = 70
      , promptBorderWidth = 3
      , font              = "xft:inconsolata:size=16"
      }
