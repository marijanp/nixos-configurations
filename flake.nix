{
  description = "marijanp's NixOS system configurations";

  nixConfig = {
    extra-substituters = [ "https://smos.cachix.org" ];
    extra-trusted-public-keys = [ "smos.cachix.org-1:YOs/tLEliRoyhx7PnNw36cw2Zvbw5R0ASZaUlpUv+yM=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    smos.url = "github:NorfairKing/smos";
    nixinate.url = "github:MatthewCroughan/nixinate";
    nixinate.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, agenix, ... }: {
    apps = inputs.nixinate.nixinate.x86_64-linux self;
    nixosConfigurations = {
      split = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            nixpkgs.nixosModules.notDetected
            ./machines/split/hardware-configuration.nix
            ./users/marijan/base.nix
            ./environments/work.nix
            ./services/yubikey.nix
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              system.stateVersion = "23.11";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marijan = {
                imports = [
                  ./users/marijan/home.nix
                  ./dotfiles/work.nix
                ];
              };
              home-manager.extraSpecialArgs = { inherit inputs; };
            })
          ];
        specialArgs = { inherit inputs; hostName = "split"; };
      };

      splitpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-z13
          ./machines/splitpad/hardware-configuration.nix
          ./users/marijan/base.nix
          ./environments/work.nix
          ./services/yubikey.nix
          ./services/printing.nix
          agenix.nixosModules.age
          home-manager.nixosModules.home-manager
          ({ pkgs, ... }: {
            system.stateVersion = "23.11";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marijan = {
              imports = [
                ./users/marijan/home.nix
                ./dotfiles/work.nix
              ];
            };
            home-manager.extraSpecialArgs = { inherit inputs; };
          })
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
          {
            _module.args.nixinate = {
              host = "192.168.1.77";
              sshUser = "marijan";
              buildOn = "remote"; # valid args are "local" or "remote"
              substituteOnTarget = false; # if buildOn is "local" then it will substitute on the target, "-s"
              hermetic = false;
            };
          }
          ({ pkgs, ... }: {
            system.stateVersion = "22.11";
          })
        ];
        specialArgs = { inherit inputs; hostName = "splitberry"; };
      };
    };
  };
}
