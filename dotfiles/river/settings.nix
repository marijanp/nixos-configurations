{ lib, isLaptop }:
{
  default-layout = "rivercarro";

  background-color = "0x000000";
  border-color-unfocused = "0x81a1c1";
  border-color-focused = "0x88c0d0";
  border-width = 1;
  focus-follows-cursor = "normal";

  map = {
    normal = {
      # define tags (river uses bitmasks)
      "Super 1" = "set-focused-tags 1";
      "Super 2" = "set-focused-tags 2";
      "Super 3" = "set-focused-tags 4";
      "Super 4" = "set-focused-tags 8";

      # move windows to tags
      "Super+Shift 1" = "set-view-tags 1";
      "Super+Shift 2" = "set-view-tags 2";
      "Super+Shift 3" = "set-view-tags 4";
      "Super+Shift 4" = "set-view-tags 8";

      # keybindings
      "Super Return".spawn = "kitty";
      "Super D".spawn = "'rofi -show run'";
      "Super+Shift L".spawn = "'loginctl lock-session'";

      # multimedia
      "None XF86AudioRaiseVolume".spawn = "'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+'";
      "None XF86AudioLowerVolume".spawn = "'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-'";
      "None XF86AudioMute".spawn = "'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
      "None XF86AudioMicMute".spawn = "'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'";
      "None XF86MonBrightnessUp".spawn = "'brightnessctl set +5%'";
      "None XF86MonBrightnessDown".spawn = "'brightnessctl set 5%-'";
      "None Print".spawn = "'grim -g \"$(slurp)\"'";

      # window management
      "Super Q" = "close";
      "Super Tab" = "focus-view next";
      "Super J" = "focus-view next";
      "Super K" = "focus-view previous";
      "Super+Shift J" = "swap next";
      "Super+Shift K" = "swap previous";

      # layout control
      "Super H" = "send-layout-cmd rivercarro 'main-ratio -0.05'";
      "Super L" = "send-layout-cmd rivercarro 'main-ratio +0.05'";
      "Super F" = "toggle-float";
      "Super Space" = "send-layout-cmd rivercarro 'main-location-cycle monocle,left,top'";
    };
  };

  rule-add = {
    "-app-id" = {
      firefox.tags = 1;
      thunderbird.tags = 1;
      kitty.tags = 2;
      "info.mumble.Mumble".tags = 4;
      Element.tags = 4;
      signal.tags = 4;
      "im.dino.Dino".tags = 4;
      Gimp = "float";
      control = "float";
      error = "float";
      file_progress = "float";
      dialog = "float";
      download = "float";
      Update = "float";
      notification = "float";
      confirm = "float";
      splash = "float";
      toolbar = "float";
    };
  };
  spawn =
    lib.optionals isLaptop [
      "'wlr-randr --output eDP-1 --scale 2'"
    ]
    ++ [
      "waybar"
      "'rivercarro -main-location monocle'" # make the monocle layout the default
      "firefox"
      "kitty"
    ];
}
