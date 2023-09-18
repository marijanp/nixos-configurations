{ pkgs, config, ... }: {
  programs.bash.shellAliases = {
    switch-projector = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1 --auto \
        --output DP-1 --mode 1920x1080 --scale 2x2 --pos 2880x0
    '';
    switch-dock = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1 --off \
        --output DP-9 --mode 1920x1080 --scale 2x2 \
        --output DP-10 --mode 1920x1080 --scale 2x2 --pos 3840x0
    '';
    switch-default = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${builtins.toString config.services.xserver.dpi} \
        --output eDP-1  --auto \
        --output DP-9 --off \
        --output DP-10 --off
    '';
  };
}
