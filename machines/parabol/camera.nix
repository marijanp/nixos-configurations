{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.local.parabol.camera;
in
{
  options.local.parabol.camera.enable =
    lib.mkEnableOption "the OV5647 Raspberry Pi camera on parabol";

  config = lib.mkIf cfg.enable {
    # The MakerHawk IR fisheye module uses the OV5647 sensor. If /dev/video0
    # does not appear, the Raspberry Pi firmware config may still need:
    #   gpu_mem=128
    #   start_x=1
    boot.kernelModules = [ "bcm2835-v4l2" ];

    environment.systemPackages = with pkgs; [ v4l-utils ];

    services.ustreamer = {
      enable = true;
      device = "/dev/video0";
      extraArgs = [
        "--resolution=1280x960"
        "--quality=100"
        "--desired-fps=10"
      ];
    };
  };
}
