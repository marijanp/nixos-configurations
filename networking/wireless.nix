{ config, pkgs, ... }:

{
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.networks = {
    "WLAN-280772" = {
      pskRaw = "ad679f5e4fb1fcce5444843e46e3e0f8e288efeda0116d84c98c104f55fbfadf";
    };
  };
}