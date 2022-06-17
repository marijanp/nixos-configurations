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

  services.xserver = {
    enable = true;
    displayManager.sddm.enable= true;
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
    desktopManager.wallpaper = {
      mode = "center";
      combineScreens = true;
    };
    videoDrivers = [ "nvidia" "intel" ];
    layout = "us+keypad(x11)";
    xkbOptions = "eurosign:e";
  };
}
