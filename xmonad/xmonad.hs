module Main (main) where

import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeys)

main :: IO ()
main =
  xmonad $ def
    { -- borderWidth = 0
      focusedBorderColor = "grey"
    , layoutHook = avoidStruts $ layoutHook def
    , manageHook = manageDocks <+> manageHook' <+> manageHook def
    , modMask = windowsKey
    , terminal = "termite"
    , workspaces = ["emacs", "web", "social"] ++ map show [4..9]
    } `additionalKeys` keys
  where
    windowsKey = mod4Mask
    manageHook' =
      composeAll [ className =? "Gimp" --> doFloat ]
    keys =
      [ -- ((windowsKey .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
      ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
      -- , ((modMask, xK_Return), spawn (XMonad.terminal conf))
      , ((0, xK_Print), spawn "scrot")
        -- TODO add mod-o for switch other window
      ]
