{ hostName, ... }:
{
  networking = {
    inherit hostName;
    enableIPv6 = false;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
}
