module Main (main) where

import           System.Exit
import           XMonad
import           XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import           XMonad.Util.EZConfig

main :: IO ()
main =
  xmonad $ def
    { focusedBorderColor = "gray"
    , normalBorderColor = "black"
    , layoutHook = avoidStruts layout
    , manageHook = manageDocks <+> manageHook def
    , modMask = mod4Mask -- windows key
    , terminal = "termite"
    } `removeKeysP` unbindings `additionalKeysP` bindings

layout = tiled ||| Mirror tiled ||| Full
  where
    tiled = Tall
      { tallNMaster        = 1
      , tallRatioIncrement = 5/100
      , tallRatio          = 2/3
      }

bindings =
  [ ("M-k",        kill)
  , ("M-O",        windows W.focusUp)
  , ("M-o",        windows W.focusDown)
  , ("M-q",        io exitSuccess)
  , ("M-r",        spawn "xmonad --recompile && xmonad --restart")
  , ("M-x",        spawn "dmenu_run")
  , ("M-<Down>",   withFocused (windows . W.sink))
  , ("M-<Left>",   sendMessage Shrink)
  , ("M-<Right>",  sendMessage Expand)
  , ("M-?",        spawn "xprop | grep WM_CLASS")
  ]

unbindings =
  [ "M-?"
  , "M-j"
  , "M-J"
  , "M-K"
  , "M-p"
  ]
