{ config, pkgs, ... }:
{
  # Enable sound.
  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

}
