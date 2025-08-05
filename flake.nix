{
  description = "marijanp's NixOS system configurations";

  nixConfig = {
    extra-substituters = [
      "https://smos.cachix.org"
    ];
    extra-trusted-public-keys = [
      "smos.cachix.org-1:YOs/tLEliRoyhx7PnNw36cw2Zvbw5R0ASZaUlpUv+yM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";
    smos.url = "github:NorfairKing/smos";
    smos.inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nur, agenix, smos }:
    let
      customOverlay =
        final: prev: {
          inherit (agenix.packages.x86_64-linux) agenix;
        };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = {
        split = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgsSrc = nixpkgs; hostName = "split"; };

          modules = [
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            ./machines/split/hardware-configuration.nix
            ./users/marijan/base.nix
            ./environments/desktop.nix
            ./services/yubikey.nix
            ./services/printing.nix
            ./services/prometheus.nix
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            {
              system.stateVersion = "23.11";
              nixpkgs.overlays = [
                customOverlay
                nur.overlays.default
              ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.marijan = {
                  imports = [
                    smos.homeManagerModules.x86_64-linux.default
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
          specialArgs = { nixpkgsSrc = nixpkgs; hostName = "splitpad"; };

          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen1
            ./machines/splitpad/hardware-configuration.nix
            ./users/marijan/base.nix
            ./environments/desktop.nix
            ./services/yubikey.nix
            ./services/printing.nix
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            {
              system.stateVersion = "22.11";
              nixpkgs.overlays = [
                customOverlay
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
                    smos.homeManagerModules.x86_64-linux.default
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
          specialArgs = { nixpkgsSrc = nixpkgs; hostName = "splitberry"; };

          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./machines/splitberry/hardware-configuration.nix
            ./machines/splitberry/networking.nix
            ./users/marijan/base.nix
            ./environments/common.nix
            ./services/prometheus.nix
            {
              system.stateVersion = "22.11";
            }
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
