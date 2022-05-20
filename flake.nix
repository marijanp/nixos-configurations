{
  description = "marijanp's NixOS system configurations";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
    home-manager.url = github:nix-community/home-manager/release-21.11;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {
      split =  nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [ 
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              # Let 'nixos-version --json' know about the Git revision of this flake.
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              imports = [
                ./machines/split/hardware-configuration.nix
                ./users/marijan/base.nix
                ./environments/desktop.nix
                ./environments/work.nix
                ./options/wireless.nix
                #../../services/services.nix
                #../../services/mongodb.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marijan = import ./dotfiles/desktop.nix;

              networking = {
                hostName = "split";
                interfaces = {
                  eno1.useDHCP = true;
                  wlp3s0u1 = {
                    useDHCP = false;
                    ipv4.addresses = [ {
                    address = "192.168.1.190";
                    prefixLength = 24;
                    } ];
                  };
                };
                wireless = {
                  enable = true;
                  interfaces = ["wlp3s0u1"];
                };
                defaultGateway = "192.168.1.1";
                nameservers = ["8.8.8.8"];
                useDHCP = false;
              };
            })
          ];
          
      };
    };

  };
}
