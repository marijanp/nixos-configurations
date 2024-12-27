{ pkgs, config, ... }: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "switch-to-dock" ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${
        builtins.toString config.services.xserver.dpi
      } \
        --output eDP-1 --off \
        --output DP-"$1" --mode 1920x1080 --scale 2x2 \
        --output DP-"$2" --mode 1920x1080 --scale 2x2 --pos 3840x0
    '')
    (pkgs.writeShellScriptBin "switch-from-dock" ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${
        builtins.toString config.services.xserver.dpi
      } \
        --output eDP-1  --auto \
        --output "DP-$1" --off \
        --output "DP-$2" --off
    '')
  ];
  programs.bash.shellAliases = {
    switch-to-projector = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${
        builtins.toString config.services.xserver.dpi
      } \
        --output eDP-1 --auto \
        --output DP-1 --mode 1920x1080 --scale 2x2 --pos 2880x0
    '';
    switch-from-projector = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi ${
        builtins.toString config.services.xserver.dpi
      } \
        --output eDP-1 --auto \
        --output DP-1 --off
    '';
  };
}
