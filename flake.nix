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
    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.flake = false;
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nur, wayland-pipewire-idle-inhibit }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = {
        split = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgsSrc = nixpkgs; };

          modules = [
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            ./machines/split/hardware-configuration.nix
            ./users/marijan/base.nix
            ./environments/desktop.nix
            ./services/yubikey.nix
            ./services/prometheus.nix
            home-manager.nixosModules.home-manager
            {
              system.stateVersion = "23.11";
              networking.hostName = "split";
              nixpkgs.overlays = [
                nur.overlays.default
              ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.marijan = {
                  imports = [
                    ./users/marijan/home.nix
                    ./dotfiles/desktop.nix
                  ];
                };
              };
            }
          ];
        };

        splitpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgsSrc = nixpkgs; };

          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen1
            ./machines/splitpad/hardware-configuration.nix
            ./users/marijan/base.nix
            ./environments/desktop.nix
            ./services/yubikey.nix
            home-manager.nixosModules.home-manager
            {
              system.stateVersion = "22.11";
              networking.hostName = "splitpad";
              services.tailscale.useRoutingFeatures = "client";
              nixpkgs.overlays = [
                nur.overlays.default
              ];

              networking.extraHosts = ''
                127.0.0.1 laganinix.local
                127.0.0.1 agent.laganinix.local
              '';

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.marijan = {
                  imports = [
                    (import "${wayland-pipewire-idle-inhibit}/modules/home-manager.nix")
                    ./users/marijan/home.nix
                    ./dotfiles/desktop.nix
                  ];
                };
              };
            }
          ];
        };

        splitberry = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { nixpkgsSrc = nixpkgs; };

          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./machines/splitberry/hardware-configuration.nix
            ./machines/splitberry/networking.nix
            ./users/marijan/base.nix
            ./environments/common.nix
            ./services/prometheus.nix
            ./services/printing.nix
            {
              system.stateVersion = "22.11";
              networking.hostName = "splitberry";
              services.tailscale = {
                useRoutingFeatures = "server";
                extraUpFlags = [ "--advertise-exit-node" "--exit-node" ];
              };
            }
          ];
        };

        split3d = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { nixpkgsSrc = nixpkgs; };

          modules = [
            nixos-hardware.nixosModules.raspberry-pi-3
            ./machines/splitberry/networking.nix
            ./machines/split3d/camera.nix
            ./users/marijan/base.nix
            ./environments/common.nix
            ./services/prometheus.nix
            ./services/klipper
            ({ modulesPath, ...}: {
              imports = [
                (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
              ];
              system.stateVersion = "25.11";
              networking.hostName = "split3d";
            })
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
