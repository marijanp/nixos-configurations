{ hostName, ... }:
{
  networking = {
    inherit hostName;
    enableIPv6 = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
}
