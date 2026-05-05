{
  config,
  lib,
  nixos-hardware,
  pkgs,
  ...
}:
{
  imports = [
    "${nixos-hardware}/radxa"
    "${nixos-hardware}/rockchip"
  ];

  config = {
    hardware = {
      radxa.enable = true;
      rockchip = {
        rk3588.enable = true;
        # TODO: Delete this vendored module once the upstream nixos-hardware
        # Rock 5C fix is merged and this repository can switch back.
        platformFirmware = lib.mkDefault pkgs.ubootRock5ModelC;
      };
    };
  };
}
