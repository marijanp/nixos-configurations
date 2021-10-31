{ config, pkgs, options, ... }:
let
  splitpkgs = builtins.fetchGit {
    url = "git@github.com:marijanp/splitpkgs.git";
    ref = "refs/heads/master";
  };
  vim-custom = import custom-applications/vim-custom.nix { inherit pkgs; }; 
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
    keyMap = "us";
  };
  
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "Europe/Berlin";

  environment = {
    systemPackages = with pkgs; [
      curl
      git
      gnupg
      tmux
      unzip
      vim-custom
      wget
      zip
    ];
  };

  programs = {
    vim.defaultEditor = true;
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
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuIz0wFEPdBpR8RZkR2dnX57TPlsv69sUN0I9WjR6jj marijan@laganini"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRDEu0YvbI33NNrAPrFKhl2EHs/1cNfSv6g7rLrvD19 marijan@iphone"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGAi1cv+zFpMnjgEsTs9ytHeUVQX+GSgtNgI1YAMpdg marijan@splitbook"
      ];
  };

  # Automatic Upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-21.05;
}
