{ config, pkgs, options, ... }:
let
  splitpkgs = builtins.fetchGit {
    url = "git@github.com:marijanp/splitpkgs.git";
    ref = "refs/heads/master";
  };
in
{
  imports = [
    ./nixpkgs-config.nix
  ];

  nix.nixPath =
    options.nix.nixPath.default ++ [
      "splitpkgs=${splitpkgs}/"
    ]
  ;

  # internationalisation
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
  
  i18n.defaultLocale = "de_DE.UTF-8";

  time.timeZone = "Europe/Berlin";

  environment = {
    systemPackages = with pkgs; [
      curl
      git
      oh-my-zsh
      tmux
      unzip
      custom-vim
      wget
      zsh
      zip
    ];
  };

  programs = {
    vim.defaultEditor = true;
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "amuse";
        plugins = [ "git" "tmux" ];
      };
   };
  };

  # ssh
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuIz0wFEPdBpR8RZkR2dnX57TPlsv69sUN0I9WjR6jj marijan@laganini"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRDEu0YvbI33NNrAPrFKhl2EHs/1cNfSv6g7rLrvD19 marijan@iphone"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGAi1cv+zFpMnjgEsTs9ytHeUVQX+GSgtNgI1YAMpdg marijan@splitbook"
      ];
  };

  # Automatic Upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-20.03;
}
