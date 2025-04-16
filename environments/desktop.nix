{ pkgs, lib, ... }:
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
  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_cmd = "${lib.getExe pkgs.slurp} -f %o -or";
          chooser_type = "simple";
        };
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "wlr" "gtk" ];
      river.default = [ "wlr" "gtk" ];
    };
  };
}
