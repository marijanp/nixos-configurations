{ pkgs, config, ... }: {

  networking = {
    interfaces = {
      wlp13s0.useDHCP = true;
    };
    wireless = {
      interfaces = [ "wlp13s0" ];
    };
  };

  imports = [ ../../options/wireless.nix ];
}
