{ pkgs, ... }:
{
  hardware.gpgSmartcards.enable = true;
  services.pcscd.enable = true;
  security.pam = {
    # to generate the settings.authfile run
    # pamu2fcfg > ~/.config/Yubico/u2f_keys
    u2f = {
      enable = true;
      settings.cue = true;
    };
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      waylock.u2fAuth = true;
    };
  };
  services.udev.packages = [ pkgs.yubikey-personalization ];
  security.polkit.enable = true;
}
