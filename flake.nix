{
  description = "marijanp's NixOS system configurations";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    home-manager.url = github:nix-community/home-manager/release-22.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    splitpkgs.url = "git+ssh://git@github.com/marijanp/splitpkgs.git";
    splitpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, splitpkgs }: {
    nixosConfigurations = {
      split = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              system.stateVersion = "22.05";
              # Let 'nixos-version --json' know about the Git revision of this flake.
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = nixpkgs;
              imports = [
                ./machines/split/hardware-configuration.nix
                ./machines/split/networking.nix
                ./users/marijan/base.nix
                ./environments/work.nix
                ./options/wireless.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marijan = { imports = [ ./users/marijan/home.nix ./dotfiles/work.nix ]; };
              # home-manager.extraSpecialArgs = { inherit splitpkgs; };
            })
          ];
      };
      splitberry = {
        modules = [
          nixpkgs.nixosModules.notDetected
          ({ pkgs, ... }: {
            system.stateVersion = "22.05";
            # Let 'nixos-version --json' know about the Git revision of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            imports = [
              ./machines/splitberry/hardware-configuration.nix
              ./users/marijan/base.nix
              ./environments/common.nix
              ./options/wireless.nix
              ./services/nastavi.nix
            ];
          })
        ];
      };
    };
    qemu-image =
      let
        nixpkgsSource = nixpkgs.sourceInfo.outPath;
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
      in
      import (nixpkgsSource + "/nixos/lib/make-disk-image.nix") {
        inherit pkgs lib;
        format = "qcow2";
        diskSize = "20000";
        config = (import (nixpkgsSource + "/nixos/lib/eval-config.nix") {
          inherit pkgs system;
          modules = [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            (nixpkgsSource + "/nixos/modules/profiles/qemu-guest.nix")
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
            })
          ];
        }).config;
      };
  };
}
