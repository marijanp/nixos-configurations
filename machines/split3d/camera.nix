{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ v4l-utils ];
  services.ustreamer = {
    enable = true;
    device = "/dev/video0";
    extraArgs = [ "--resolution=1280x960" "--quality=100" "--desired-fps=10" ];
  };
  boot.kernelModules = [ "bcm2835-v4l2" ];
}
