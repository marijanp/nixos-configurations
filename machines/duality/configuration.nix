{
  config,
  pkgs,
  lib,
  certilia,
  nur,
  nixos-hardware,
  home-manager,
  sops-nix,
  ...
}:
{

  system.stateVersion = "26.05";
  networking.hostName = "duality";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports = [
    (import "${nixos-hardware}/asus/proart/px13/hn7306eac")
    ./hardware-configuration.nix
    ./networking.nix
    ./bluetooth.nix
    ../../users/marijan/base.nix
    ../../system/desktop.nix
    ../../system/services/yubikey.nix
    sops-nix.nixosModules.sops
    ../../system/sops.nix
    home-manager.nixosModules.home-manager
    ../../system/services/syncthing
    ../../system/services/syncthing/obsidian-vault.nix
    ../../system/services/steam.nix
    ./steam-library.nix
    ./synapse-wg.nix
    ./nix-ci.nix
  ];

  nixpkgs.overlays = [
    nur.overlays.default
    certilia.overlays.default
    (import ../../overlay.nix)
  ];

  services.printing.enable = true;

  sops = {
    defaultSopsFile = ../../secrets/duality.yaml;
    secrets.opencode-zen-api-key = {
      owner = config.users.users.marijan.name;
    };
    secrets.nix-gh-token = { };
    templates."nix-access-tokens.conf" = {
      owner = config.users.users.marijan.name;
      mode = "0400";
      content = ''
        access-tokens = github.com=${config.sops.placeholder.nix-gh-token}
      '';
    };
  };

  nix.extraOptions = ''
    !include ${config.sops.templates."nix-access-tokens.conf".path}
  '';

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.marijan = {
      imports = [
        ../../users/marijan/home.nix
        ../../dotfiles/desktop.nix
        ../../dotfiles/voxtype.nix
        ../../dotfiles/opencode.nix
        ../../dotfiles/certilia.nix
      ];
    };
  };

  console = {
    earlySetup = true;
    font = "ter-v32n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  services.libinput.touchpad = {
    disableWhileTyping = true;
    tapping = false;
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="amdsoundwire", RUN+="${lib.getBin pkgs.alsa-utils}/bin/amixer -c $attr{device/number} set 'tas2783-1 Amp' on"
    ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="amdsoundwire", RUN+="${lib.getBin pkgs.alsa-utils}/bin/amixer -c $attr{device/number} set 'tas2783-2 Amp' on"
    ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="amdsoundwire", RUN+="${lib.getBin pkgs.alsa-utils}/bin/amixer -c $attr{device/number} set 'tas2783-1 Speaker' on"
    ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="amdsoundwire", RUN+="${lib.getBin pkgs.alsa-utils}/bin/amixer -c $attr{device/number} set 'tas2783-2 Speaker' on"
  '';
}
