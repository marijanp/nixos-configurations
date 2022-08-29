{ config, pkgs, lib, ... }:
{
  services.openssh = {
    enable = true;
    # Disable OpenSSH password login
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  users.users.marijan.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuIz0wFEPdBpR8RZkR2dnX57TPlsv69sUN0I9WjR6jj marijan@laganini"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEm0jqNuG+NtkVVqa8s+kB+klSYCEctWbrskSiT440sW marijan@split"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDxBJkP4DBqhKhgPwy1WEPsF/H9q4cpZWUmNZP1pScPg marijan@splitpad"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRDEu0YvbI33NNrAPrFKhl2EHs/1cNfSv6g7rLrvD19 marijan@iphone"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGAi1cv+zFpMnjgEsTs9ytHeUVQX+GSgtNgI1YAMpdg marijan@splitbook"
  ];
}
