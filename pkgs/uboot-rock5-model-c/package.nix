{
  buildUBoot,
  armTrustedFirmwareRK3588,
  rkbin,
}:

# TODO: Delete this vendored package once upstream nixpkgs includes
# ubootRock5ModelC and the repository can switch back to that package.
buildUBoot {
  defconfig = "rock-5c-rk3588s_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  env = {
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
  };
  filesToInstall = [
    "u-boot.itb"
    "idbloader.img"
    "u-boot-rockchip.bin"
    "u-boot-rockchip-spi.bin"
  ];
}
