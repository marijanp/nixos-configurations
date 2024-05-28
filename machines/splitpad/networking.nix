{ pkgs, config, ... }: {
  networking = {
    interfaces = {
      wlp1s0.useDHCP = true;
    };
    wireless = {
      interfaces = [ "wlp1s0" ];
    };
  };

  networking.networkmanager.enable = true;
}
