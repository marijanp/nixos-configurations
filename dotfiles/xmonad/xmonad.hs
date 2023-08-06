import XMonad
import XMonad.Util.EZConfig (additionalKeysP)

import XMonad.Hooks.EwmhDesktops (ewmhFullscreen, ewmh)

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Layout.NoBorders (smartBorders)

import XMonad.Actions.Volume (raiseVolume, lowerVolume, toggleMute)

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . xmobarProp $ xmonadConfig

xmonadConfig = def {
    modMask = mod4Mask
  , terminal = "kitty"
  , normalBorderColor = "#c8d6e5"
  , focusedBorderColor = "#64FFDA"
  , workspaces = ["1:web","2:code","3:chat"] ++ (show <$> [5..9])
  , layoutHook = smartBorders layoutHookConfig
  , manageHook = manageHookConfig
  }
  `additionalKeysP`
  [ ("M-f", spawn "firefox")
  , ("M-d", spawn "rofi -show run -theme nord")
  , ("M-S-l", spawn "xsecurelock") -- Mod + Shift + l
  , ("<XF86AudioRaiseVolume>", raiseVolume 2 >> pure ())
  , ("<XF86AudioLowerVolume>", lowerVolume 2 >> pure ())
  , ("<XF86AudioMute>", toggleMute >> pure ())
  , ("<XF86AudioMicMute>", spawn "amixer set Capture toggle")
  , ("<XF86MonBrightnessUp>", spawn "brightnessctl set +5%")
  , ("<XF86MonBrightnessDown>", spawn "brightnessctl set 5%-")
  , ("<Print>", spawn "scrot 'scrot-%Y-%m-%d_$wx$h.png' -e 'optipng $f' -s")
  ]

manageHookConfig = composeAll [
    className =? "firefox"            --> doShift "1:web"
  , className =? "kitty"              --> doShift "2:code"
  , className =? "Element"            --> doShift "3:chat"
  , className =? "signal-desktop"     --> doShift "3:chat"
  , className =? "control"            --> doFloat
  , className =? "error"              --> doFloat
  , className =? "file_progress"      --> doFloat
  , className =? "dialog"             --> doFloat
  , className =? "download"           --> doFloat
  , className =? "Gimp"               --> doFloat
  , className =? "Update"             --> doFloat
  , className =? "notification"       --> doFloat
  , className =? "confirm"            --> doFloat
  , className =? "splash"             --> doFloat
  , className =? "toolbar"            --> doFloat
  ] 

layoutHookConfig = Full ||| tiled ||| Mirror tiled
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes

