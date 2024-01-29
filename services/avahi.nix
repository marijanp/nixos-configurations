{ config, pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish.enable = true;
    publish.addresses = true;
  };
}
