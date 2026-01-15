{ ... }: {

  networking = {
    interfaces = {
      wlp13s0.useDHCP = true;
      enp12s0 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
    };
    wireless = {
      interfaces = [ "wlp13s0" ];
    };
  };
}
