{ lib, isLaptop }: {
  mainBar = {
    output = [ "eDP-1" ];
    layer = "top";
    position = "bottom";
    modules-left = [ "river/tags" ];
    modules-center = [ "river/window" ];
    modules-right = [
      "river/layout"
      "cpu"
      "memory"
    ] ++ lib.optionals isLaptop [
      "battery"
      "backlight"
    ] ++ [
      "pulseaudio"
      "clock"
    ];
    "river/tags" = {
      num-tags = 4;
      tag-labels = [ "web" "code" "chat" "other" ];
    };
    "river/layout" = {
      format = "{}";
      min-length = 4;
    };
    "river/window" = {
      format = "{}";
      max-length = 80;
    };
    cpu = {
      interval = 1;
      format = "CPU: {usage}%";
    };
    memory = {
      interval = 1;
      format = "RAM: {used:0.1f}G ({percentage}%)";
    };
    battery = {
      interval = 20;
      states = {
        low = 15;
        high = 80;
      };
      format = "{capacity}% {time}";
      format-charging = "Charging {capacity}%";
      format-plugged = "Charged";
    };
    backlight = {
      device = "amdgpu_bl1";
      format = "Br: {percent}%";
    };
    pulseaudio = {
      format = "Vol: {volume}% {icon}";
      format-muted = "Muted";
    };
    clock = {
      interval = 60;
      format = "{:%a, %d. %b - %H:%M}";
    };
  };
}
