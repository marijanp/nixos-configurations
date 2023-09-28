{ pkgs, config, ... }: {
  programs.bash.shellAliases = {
    switch-to-dock = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1 --off \
        --output DP-9 --mode 1920x1080 --scale 2x2 \
        --output DP-10 --mode 1920x1080 --scale 2x2 --pos 3840x0
    '';
    switch-from-dock = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1  --auto \
        --output DP-9 --off \
        --output DP-10 --off
    '';
    switch-to-projector = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1 --auto \
        --output DP-1 --mode 1920x1080 --scale 2x2 --pos 2880x0
    '';
    switch-from-projector = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1 --auto \
        --output DP-1 --off
    '';
    switch-to-casper = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1 --auto \
        --output DP-1 --mode 2560x1440 --scale 2x2 --pos 2880x0
    '';
    switch-from-casper = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1 --auto \
        --output DP-1 --off
    '';
  };
}
