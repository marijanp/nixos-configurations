{ config, pkgs, ... }:

{

  # internationalisation properties
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "Europe/Berlin";

  # Allow packages with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      curl
      git
      oh-my-zsh
      tmux
      unzip
      vim
      wget
      zsh
      zip
    ];
  };

  programs = {
    vim.defaultEditor = true;
    zsh.ohMyZsh = {
      enable = true;
      theme = "amuse";
      plugins = [ "git" "tmux" ];
    };
  };

  # ssh
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # Disable OpenSSH password login
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  # users
  users.users.marijan = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2x2mMML1YdAp80fp2ccOhjYllySfHKD/ISuFDHumLWjesEtbrXzl4YNFXB2K5qRxyFlKde6ib/7s/vhnL9bC3sDfZh2V981PRo+IqigLmaVR5R4c/2NVXpVlM+Z5XmSuFIvphkh6Bh+jOUHvjbKPfOVUQWeeFgt7D/mwJFKoDbzxx4ImjHC9CRFyMu2dWrHvIXO+PuHEElWaM9sYv3KSvT2YazXTJaRToSo42+ul2JOPo0vqvEAX7gs3T3YvVpUbGWyEalUp2NM7ajpT3ev1wyI2qRUvMfFKf3fO5fSEbNlFvPYWc3u2n/QtBVVXXhOHEHycmJVn86E0TbjypvFQT marijan@Marijans-MacBook-Pro.local"
      ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should
  system.stateVersion = "19.03";
  
  # Automatic Upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-unstable;
}