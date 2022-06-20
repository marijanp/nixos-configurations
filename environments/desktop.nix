{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];
  security.pam.services.swaylock = {
    text = "auth include login";
  };
}
