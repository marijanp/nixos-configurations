{ pkgs, ... }:
{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };
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
}
