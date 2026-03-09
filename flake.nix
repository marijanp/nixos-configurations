{
  description = "marijanp's NixOS system configurations";

  nixConfig = {
    extra-substituters = [
    ];
    extra-trusted-public-keys = [
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    certilia.url = "github:marijanp/certilia-overlay";
    certilia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      nur,
      sops-nix,
      certilia,
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosConfigurations = {
        split = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixpkgs; };
          modules = [
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            ./machines/split/hardware-configuration.nix
            ./machines/split/networking.nix
            ./users/marijan/base.nix
            ./system/common.nix
            ./system/services/yubikey.nix
            ./system/services/prometheus.nix
            ./system/services/ollama.nix
            ./system/services/klipper
            sops-nix.nixosModules.sops
            ./system/sops.nix
            home-manager.nixosModules.home-manager
            (
              { pkgs, lib, ... }:
              {
                system.stateVersion = "23.11";
                networking.hostName = "split";
                nixpkgs.overlays = [
                ];

                boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_18;

                sops = {
                  defaultSopsFile = ./secrets/split.yaml;
                  secrets.wg-private-key = { };
                };

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.marijan = {
                    imports = [
                      ./users/marijan/home.nix
                      ./dotfiles/common.nix
                    ];
                  };
                };
              }
            )
          ];
        };

        splitpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixpkgs; };
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen1
            ./machines/splitpad/hardware-configuration.nix
            ./machines/splitpad/networking.nix
            ./users/marijan/base.nix
            ./system/desktop.nix
            ./system/services/yubikey.nix
            ./system/services/steam.nix
            sops-nix.nixosModules.sops
            ./system/sops.nix
            home-manager.nixosModules.home-manager
            ./system/services/syncthing
            (
              { config, ... }:
              {
                system.stateVersion = "22.11";
                networking.hostName = "splitpad";

                nixpkgs.overlays = [
                  nur.overlays.default
                  certilia.overlays.default
                  (import ./overlay.nix)
                ];


                services.printing.enable = true;

                sops = {
                  defaultSopsFile = ./secrets/splitpad.yaml;
                  secrets.wg-private-key = { };
                  secrets.opencode-zen-api-key = {
                    owner = config.users.users.marijan.name;
                  };
                  secrets.syncthing-password = { };
                };

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.marijan = {
                    imports = [
                      ./users/marijan/home.nix
                      ./dotfiles/desktop.nix
                      ./dotfiles/opencode.nix
                      ./dotfiles/certilia.nix
                    ];
                  };
                };
              }
            )
          ];
        };

        splitberry = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit nixpkgs; };
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./machines/splitberry/hardware-configuration.nix
            ./machines/splitberry/networking.nix
            ./machines/splitberry/nginx.nix
            sops-nix.nixosModules.sops
            ./system/sops.nix
            ./modules/luks.nix
            ./users/marijan/base.nix
            ./system/common.nix
            ./system/services/adguard.nix
            ./system/services/prometheus.nix
            ./system/services/printing.nix
            ./system/services/syncthing
            ./system/services/syncthing/photos.nix
            ./system/services/jellyfin.nix
            (
              { config, ... }:
              {
                system.stateVersion = "22.11";
                networking.hostName = "splitberry";

                nix.gc = {
                  automatic = true;
                  dates = "weekly";
                  options = "--delete-older-than 7d";
                };

                sops = {
                  defaultSopsFile = ./secrets/splitberry.yaml;
                  secrets.wg-private-key = { };
                  secrets.usb-drive-key = { };
                };

                services.luks.devices.usb-drive = {
                  device = "/dev/disk/by-uuid/948a5ffa-a1f2-4874-b646-fab5090eae74";
                  mountPoint = "/mnt/usb-drive";
                  keyFile = config.sops.secrets.usb-drive-key.path;
                  keyService = "sops-nix.service";
                };
              }
            )
          ];
        };

        split3d = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit nixpkgs; };
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-3
            ./machines/split3d/hardware-configuration.nix
            ./machines/split3d/networking.nix
            ./machines/split3d/camera.nix
            ./users/marijan/base.nix
            ./system/common.nix
            ./system/services/prometheus.nix
            ./system/services/klipper
            (
              { modulesPath, ... }:
              {
                imports = [
                  (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
                ];
                system.stateVersion = "25.11";
                networking.hostName = "split3d";
              }
            )
          ];
        };
      };

      homeConfigurations = {
        splitbook = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-darwin";
          modules = [
            ./machines/macbook/home.nix
            {
              home.stateVersion = "24.05";
            }
          ];
        };
      };
    };
}
