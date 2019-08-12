{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE RecordWildCards #-}

{-# OPTIONS_GHC -Wno-missing-signatures #-}

module Main (main) where

import           Data.Ratio
import           System.Exit
import           XMonad
import           XMonad.Actions.UpdatePointer
import           XMonad.Config.Desktop
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Layout.NoBorders (noBorders)
import           XMonad.Prompt
import           XMonad.Prompt.ConfirmPrompt
import qualified XMonad.StackSet as W
import           XMonad.Util.EZConfig

main :: IO ()
main = xmonad conf
  where
    conf = desktopConfig
      { focusedBorderColor = "#888888"
      , normalBorderColor  = "#000000"
      , layoutHook  = desktopLayoutModifiers (tiled ||| Mirror tiled) ||| noBorders Full
      , logHook     = updatePointer (0.5, 0.5) (0, 0) <+> logHook desktopConfig
      , keys        = flip mkKeymap keymap
      , manageHook  = manageHooks <+> manageDocks <+> manageHook desktopConfig
      , modMask     = mod4Mask -- windows key
      , startupHook = pure () >> checkKeymap conf keymap
      , terminal    = "termite"
      }
    keymap = bindings conf

    tiled = Tall
      { tallNMaster        = 1
      , tallRatioIncrement = 4/100
      , tallRatio          = 2/3
      }

bindings XConfig{..} =
  [ ("M-a"       , spawn xmonadReload)
  , ("M-r"       , spawn xmonadReload)

  , ("M-p"       , spawn "xprop WM_CLASS WM_NAME WM_WINDOW_ROLE | xmessage -file -")

  , ("M-q"       , confirmPrompt promptConfig "quit XMonad" (io exitSuccess))

  , ("M-x"       , spawn dmenu)
  , ("M-b"       , spawn dmenu)

  , ("M-t"       , spawn terminal)

  , ("M-h"       , sendMessage ToggleStruts)

  , ("M-k"       , kill)
  , ("M-w"       , kill)

  , ("M-o"       , windows W.focusDown)
  , ("M-n"       , windows W.focusDown)
  , ("M-<Tab>"   , windows W.focusDown)

  , ("M-m"       , windows W.focusMaster)

  , ("M-s"       , windows W.swapMaster)

  , ("M-d"       , withFocused (windows . W.sink))
  , ("M-<Left>"  , sendMessage Shrink)
  , ("M-<Right>" , sendMessage Expand)

  , ("M-<Up>"    , sendMessage (IncMasterN 1))
  , ("M-<Down>"  , sendMessage (IncMasterN (-1)))

  , ("M-;"       , spawn physlock)
  , ("M-z"       , spawn physlock)

  , ("M-l"       , sendMessage NextLayout)
  , ("M-<Space>" , sendMessage NextLayout)

  , ("<XF86MonBrightnessDown>" , spawn "sudo brightnessctl s 10%-")
  , ("<XF86MonBrightnessUp>"   , spawn "sudo brightnessctl s +10%")

  , ("<XF86AudioMute>"        , spawn "pactl -- set-sink-mute 0 toggle")
  , ("<XF86AudioLowerVolume>" , spawn "pactl -- set-sink-volume 0 -10%")
  , ("<XF86AudioRaiseVolume>" , spawn "pactl -- set-sink-volume 0 +10%")
  ]
  <> workspaceKeys ['1'..'5']
  <> workspaceKeys ['7','8','9','0']
  <> screenKeys "',."
  where
    promptConfig = def
      { position          = Top
      , alwaysHighlight   = True
      , height            = 70
      , promptBorderWidth = 3
      , font              = inconsolata
      }

    xmonadReload = "xmonad --recompile && xmonad --restart"

    dmenu = "dmenu_run -p '>>' -fn " <> inconsolata

    physlock = "sudo systemctl start physlock"

    inconsolata = "xft:inconsolata:size=18"

    workspaceKeys ns = do
      (w,n) <- zip workspaces ns
      (k,f) <- [ ([n], W.greedyView), ("S-" <> [n], W.shift) ]
      pure ( "M-" <> k
           , windows (f w)
           )

    screenKeys cs = do
      (s,c) <- zip [0..1] cs
      (k,f) <- [ ([c], W.view), ("S-" <> [c], W.shift) ]
      pure ( "M-" <> k
           , screenWorkspace s >>= maybe (pure ()) (windows . f)
           )

manageHooks = composeAll
  [ className =? "Slack"         --> doIgnore
  , className =? "Xfce4-notifyd" --> doIgnore
  , role =? "GtkFileChooserDialog" --> doRectFloat (paddedRect (1 % 4))
  ]
  where
    role = stringProperty "WM_WINDOW_ROLE"

paddedRect r =
  W.RationalRect r r w w
  where
    w = 1 - (2 * r)
