{ config, pkgs, lib, ... }:
{
  services.openssh = {
    enable = true;
    # Disable OpenSSH password login
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
