{ osConfig, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = osConfig.services.pcscd.enable;
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };
}
