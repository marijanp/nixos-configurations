{ ... }:
{
  networking = {
    enableIPv6 = true;
    nameservers = [
      "10.100.0.5"
      # quad9
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
  };
}
