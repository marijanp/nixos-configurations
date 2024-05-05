{ pkgs, ... }: {
  hardware.gpgSmartcards.enable = true;
  services.pcscd.enable = true;
  security.pam = {
    u2f.enable = true;
    yubico = {
      enable = true;
      debug = false;
      control = "sufficient";
      mode = "challenge-response";
    };
  };
  services.udev.packages = [ pkgs.yubikey-personalization ];
  security.polkit.enable = true;
}
