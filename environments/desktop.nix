{ ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];

  hardware.keyboard.zsa.enable = true;

  programs.kdeconnect.enable = true;

  age.secrets.smos-google-calendar-source = {
    file = ../secrets/smos-google-calendar-source.age;
    owner = "marijan";
  };

  age.secrets.smos-platonic-google-calendar-source = {
    file = ../secrets/smos-platonic-google-calendar-source.age;
    owner = "marijan";
  };

  age.secrets.smos-sync-password = {
    file = ../secrets/smos-sync-password.age;
    owner = "marijan";
  };

  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    xkb.options = "eurosign:e";
    displayManager.startx.enable = true;
  };
}
