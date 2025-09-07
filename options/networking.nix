{ hostName, ... }:
{
  networking = {
    inherit hostName;
    enableIPv6 = true;
    nameservers = [ "9.9.9.9" "8.8.8.8" "8.8.4.4" ];
  };
}
