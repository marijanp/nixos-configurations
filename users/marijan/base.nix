{ config, pkgs, lib, ... }:
{
  users.users.marijan = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" ];
  };
}
