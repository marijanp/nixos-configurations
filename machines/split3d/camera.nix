{ pkgs, ... }:
{
  # Manually add this to the /boot/config.txt
  # gpu_mem=128
  # start_x=1
  boot.kernelModules = [ "bcm2835-v4l2" ];
  environment.systemPackages = with pkgs; [ v4l-utils ];
  services.ustreamer = {
    enable = true;
    device = "/dev/video0";
    extraArgs = [ "--resolution=1280x960" "--quality=100" "--desired-fps=10" ];
  };
}
