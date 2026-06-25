{
  config,
  pkgs,
  certilia,
  nur,
  nixos-hardware,
  home-manager,
  sops-nix,
  noctalia,
  ...
}:
{

  system.stateVersion = "26.05";
  networking.hostName = "duality";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports = [
    nixos-hardware.nixosModules.asus-proart-px13-hn7306eac
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
    ./ollama.nix
  ];

  nixpkgs.overlays = [
    nur.overlays.default
    certilia.overlays.default
    (import ../../overlay.nix)
    (final: _prev: {
      noctalia-shell = final.callPackage "${noctalia}/nix/package.nix" { };
    })
  ];

  services.printing.enable = true;

  services.upower.enable = true;

  sops = {
    defaultSopsFile = ../../secrets/duality.yaml;
    secrets.opencode-zen-api-key = {
      owner = config.users.users.marijan.name;
    };
    secrets.gh-mcp-token = {
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
        ../../dotfiles/mcp.nix
        ../../dotfiles/opencode.nix
        ../../dotfiles/codex.nix
        ../../dotfiles/certilia.nix
        "${noctalia}/nix/home-module.nix"
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
}
