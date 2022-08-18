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
  , focusedBorderColor = "#48dbfb"
  , manageHook = manageHookConfig
  }
  `additionalKeysP`
  [ ("M-f", spawn "firefox")
  , ("M-e", spawn "codium")
  , ("M-d", spawn "rofi -show window -theme nord")
  , ("<XF86AudioRaiseVolume>", raiseVolume 2 >> pure ())
  , ("<XF86AudioLowerVolume>", lowerVolume 2 >> pure ())
  , ("<XF86AudioMute>", toggleMute >> pure ())
  , ("<XF86MonBrightnessUp>", spawn "light -A 5 && light -G | wob")
  , ("<XF86MonBrightnessDown>", spawn "light -U 5 && light -G | wob")
  ]

manageHookConfig = composeAll [
    className =? "control"         --> doFloat
  , className =? "error"           --> doFloat
  , className =? "file_progress"   --> doFloat
  , className =? "dialog"          --> doFloat
  , className =? "download"        --> doFloat
  , className =? "Gimp"            --> doFloat
  , className =? "Update"          --> doFloat
  , className =? "notification"    --> doFloat
  , className =? "confirm"         --> doFloat
  , className =? "splash"          --> doFloat
  , className =? "toolbar"         --> doFloat
  ] 