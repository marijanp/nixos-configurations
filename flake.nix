{
  description = "marijanp's NixOS system configurations";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = github:nix-community/home-manager/release-22.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    splitpkgs.url = "git+ssh://git@github.com/marijanp/splitpkgs.git";
    splitpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, splitpkgs, agenix }@inputs: {
    nixosConfigurations = {
      split = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            nixpkgs.nixosModules.notDetected
            ./machines/split/hardware-configuration.nix
            ./machines/split/networking.nix
            ./users/marijan/base.nix
            ./environments/work.nix
            ./options/wireless.nix
            ./services/yubikey.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              system.stateVersion = "22.05";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marijan = {
                imports = [
                  ./users/marijan/home.nix
                  ./dotfiles/work.nix
                ];
              };
              home-manager.extraSpecialArgs = { inherit agenix; hostName = "split"; };
            })
          ];
        specialArgs = { inherit inputs; hostName = "split"; };
      };

      splitpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            nixos-hardware.nixosModules.lenovo-thinkpad-z13
            ./machines/splitpad/hardware-configuration.nix
            ./machines/splitpad/networking.nix
            ./machines/splitpad/bluetooth.nix
            ./users/marijan/base.nix
            ./environments/work.nix
            ./services/yubikey.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              system.stateVersion = "22.05";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marijan = {
                imports = [
                  ./users/marijan/home.nix
                  ./dotfiles/work.nix
                ];
              };
              home-manager.extraSpecialArgs = { inherit agenix; hostName = "splitpad"; };
            })
          ];
        specialArgs = { inherit inputs; hostName = "splitpad"; };
      };

      splitberry = {
        modules = [
          nixpkgs.nixosModules.notDetected
          ({ pkgs, ... }: {
            system.stateVersion = "22.05";
            imports = [
              ./machines/splitberry/hardware-configuration.nix
              ./users/marijan/base.nix
              ./environments/common.nix
              ./options/wireless.nix
              ./services/nastavi.nix
            ];
          })
        ];
        specialArgs = { inherit inputs; hostName = "splitberry"; };
      };
    };
    qemu-image =
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
      in
      import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
        inherit pkgs lib;
        format = "qcow2";
        diskSize = "20000";
        config = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
          inherit pkgs system;
          modules = [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
            ({ pkgs, ... }: {
              fileSystems."/".device = "/dev/disk/by-label/nixos";
              boot.loader.grub.device = "/dev/vda";
              boot.loader.timeout = 0;
              users.extraUsers.root.password = "";
              system.stateVersion = "22.05";
              imports = [
                ./users/marijan/base.nix
                ./environments/common.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marijan = import ./dotfiles/common.nix;
              home-manager.extraSpecialArgs = { inherit agenix; hostName = "split-qemu-image"; };
            })
          ];
        }).config;
        specialArgs = { inherit inputs; hostName = "split-qemu-image"; };
      };
  };
}
