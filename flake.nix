{
  description = "marijanp's NixOS system configurations";

  nixConfig = {
    extra-substituters = [
      "https://smos.cachix.org"
      "https://feedback.cachix.org"
    ];
    extra-trusted-public-keys = [
      "smos.cachix.org-1:YOs/tLEliRoyhx7PnNw36cw2Zvbw5R0ASZaUlpUv+yM="
      "feedback.cachix.org-1:8PNDEJ4GTCbsFUwxVWE/ulyoBMDqqL23JA44yB0j1jI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";
    smos.url = "github:NorfairKing/smos";
    smos.inputs.home-manager.follows = "home-manager";
    feedback.url = "github:norfairking/feedback";
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, agenix, ... }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosConfigurations = {
      split = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.marijan = {
                imports = [
                  ./users/marijan/home.nix
                  ./dotfiles/desktop.nix
                ];
              };
            };
          }
        ];
        specialArgs = { inherit inputs; hostName = "split"; };
      };

      splitpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.marijan = {
                imports = [
                  ./users/marijan/home.nix
                  ./dotfiles/desktop.nix
                ];
              };
            };
          }
        ];
        specialArgs = { inherit inputs; hostName = "splitpad"; };
      };

      splitberry = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
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
        specialArgs = { inherit inputs; hostName = "splitberry"; };
      };
    };

    homeConfigurations = {
      splitbook = home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-darwin";
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
