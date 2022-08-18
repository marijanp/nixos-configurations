{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" "intel" ];
    layout = "us+keypad(x11)";
    xkbOptions = "eurosign:e";
    displayManager = {
      gdm.enable = true;
      defaultSession = "none+xmonad";
    };
    windowManager.xmonad = {
      enable = true;
      extraPackages = hsPkgs: with hsPkgs; [
        xmobar
      ];
      enableContribAndExtras = true;
    };
  };
}
