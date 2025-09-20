{ pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];

  hardware.keyboard.zsa.enable = true;

  programs.kdeconnect.enable = true;

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
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common.default = [ "gtk" "wlr" ];
      river.default = [ "gtk" "wlr" ];
    };
  };
}
