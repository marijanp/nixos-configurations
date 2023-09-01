{ config, pkgs, ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  environment.etc."pipewire/pipewire.conf.d/airplay.conf" = {
    mode = "0444";
    text = ''
      context.modules = [
        {
          name = libpipewire-module-raop-discover
          args = {}
        }
      ]
    '';
  };
}
