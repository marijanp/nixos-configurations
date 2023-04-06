{ config, pkgs, lib, ... }:
{
  users.users.marijan = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKJMTVrY0qbJfu2g1TocLxRrYc/AjlnUuR35Y4biaLThAAAABHNzaDo="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuIz0wFEPdBpR8RZkR2dnX57TPlsv69sUN0I9WjR6jj marijan@laganini"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEm0jqNuG+NtkVVqa8s+kB+klSYCEctWbrskSiT440sW marijan@split"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRDEu0YvbI33NNrAPrFKhl2EHs/1cNfSv6g7rLrvD19 marijan@iphone"
    ];
  };
}
