{ lib, isLaptop }: {
  mainBar = {
    output = [ "eDP-1" ];
    layer = "top";
    position = "bottom";
    modules-left = [ "river/tags" "river/window" ];
    modules-center = [ ];
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
      "idle_inhibitor"
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
      format = "MEM: {used:0.1f}G ({percentage}%)";
    };
    battery = {
      interval = 20;
      states = {
        low = 15;
        high = 80;
      };
      format = "{icon}: {capacity}% {time}";
      format-full = "{icon}";
      format-charging = "🔌{icon}: {capacity}% {time}";
      format-discharging = "{icon}: {capacity}% {time}";
      format-icons = ["🪫" "🔋"];
    };
    backlight = {
      device = "amdgpu_bl1";
      format = "☀️: {percent}%";
    };
    pulseaudio = {
      format = "{icon}: {volume}%";
      format-muted = "{icon}";
      format-bluetooth = "{icon}: {volume}% 🔗 {desc}";
      format-icons = {
        default = "🔊";
        default-muted = "🔇";
        headphones = "🎧";
      };
      on-click = "pavucontrol";
    };
    clock = {
      interval = 60;
      format = "{:%a, %d. %b - %H:%M}";
    };
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
          activated = "🕹️";
          deactivated = "💤";
      };
    };
  };
}
