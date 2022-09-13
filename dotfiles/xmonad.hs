import XMonad
import XMonad.Util.EZConfig (additionalKeysP)

import XMonad.Hooks.EwmhDesktops (ewmhFullscreen, ewmh)

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Actions.Volume (raiseVolume, lowerVolume, toggleMute)

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . xmobarProp $ xmonadConfig

xmonadConfig = def {
    modMask = mod4Mask
  , terminal = "alacritty"
  , normalBorderColor = "#c8d6e5"
  , focusedBorderColor = "#64FFDA"
  , workspaces = ["1:term","2:web","3:code","4:chat"] ++ (show <$> [5..9])
  , manageHook = manageHookConfig
  }
  `additionalKeysP`
  [ ("M-f", spawn "firefox")
  , ("M-e", spawn "codium")
  , ("M-d", spawn "rofi -show run -theme nord")
  , ("<XF86AudioRaiseVolume>", raiseVolume 2 >> pure ())
  , ("<XF86AudioLowerVolume>", lowerVolume 2 >> pure ())
  , ("<XF86AudioMute>", toggleMute >> pure ())
  , ("<XF86MonBrightnessUp>", spawn "brightnessctl set +5%")
  , ("<XF86MonBrightnessDown>", spawn "brightnessctl set 5%-")
  ]

manageHookConfig = composeAll [
    className =? "firefox"            --> doShift "2:web"
  , className =? "alacritty"          --> doShift "1:term"
  , className =? "element-desktop"    --> doShift "4:chat"
  , className =? "mattermost-desktop" --> doShift "4:chat"
  , className =? "codium"             --> doShift "3:code"
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