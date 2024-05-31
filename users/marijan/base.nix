{ config, lib, ... }:
{
  users = {
    mutableUsers = false;
    users.marijan = {
      isNormalUser = true;
      uid = 1000;
      hashedPassword = "$y$j9T$p9f//hAS.s8uGIQ6OpnKt1$o8iWFumDlAgqm8b4f2D9rb7w05yK24HNkWZf71TbnH3";
      extraGroups = [ "wheel" ] ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ];

      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKJMTVrY0qbJfu2g1TocLxRrYc/AjlnUuR35Y4biaLThAAAABHNzaDo="
      ];
    };
  };
}
