{-# LANGUAGE RecordWildCards #-}

{-# OPTIONS_GHC -Wno-missing-signatures #-}

{- HLINT ignore "Redundant pure" -}

module Main (main) where

import           Data.List (isInfixOf)
import           Data.Ratio
import           System.Exit
import           XMonad
import           XMonad.Actions.UpdatePointer
import           XMonad.Config.Desktop
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Layout.NoBorders (noBorders)
import           XMonad.Layout.ThreeColumns
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
      , layoutHook  = desktopLayoutModifiers
        ( tiled
          ||| ThreeColMid 1 (3/100) (3/4)
          ||| Mirror tiled
        ) ||| noBorders Full
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

-- 1 2 3 4 5  6 7 8 a9 0 =
-- ' , . p y  f g c r l /
-- a o e u i  d h t n s -
-- ; q j k x  b m w v z

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

  , ("<XF86AudioMute>"        , spawn "pactl -- set-sink-mute @DEFAULT_SINK@ toggle")
  , ("<XF86AudioLowerVolume>" , spawn "pactl -- set-sink-volume @DEFAULT_SINK@ -10%")
  , ("<XF86AudioRaiseVolume>" , spawn "pactl -- set-sink-volume @DEFAULT_SINK@ +10%")
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
  [ className =? "Xfce4-notifyd" --> doIgnore

  -- IntelliJ
  , (className =? "jetbrains-studio") <&&> (isInfixOf "win" <$> title) --> doIgnore
  , stringProperty "_NET_WM_NAME" =? "Emulator" --> doFloat

  -- Blueman
  , className =? ".blueman-assistant-wrapped" --> doPaddedFloat
  , name =? "Bluetooth Devices" --> doPaddedFloat

  , (className =? "zoom") <&&> (name =? "") --> doPaddedFloat

  -- pavucontrol
  , name =? "Volume Control" --> doPaddedFloat

  , role =? "GtkFileChooserDialog" --> doPaddedFloat
  ]
  where
    role = stringProperty "WM_WINDOW_ROLE"

    name = stringProperty "WM_NAME"

    doPaddedFloat = doRectFloat (paddedRect (1 % 4))

paddedRect r =
  W.RationalRect r r w w
  where
    w = 1 - (2 * r)
