{ config, pkgs, ... }:

{
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.networks = {
    "WLAN-574446" = {
	    pskRaw = "ca0f1467dbc64525d536fd4bc1dd36361868d3c72a2c51a6b043ab1520e38270";
    };
    "WLAN-280772" = {
      pskRaw = "ad679f5e4fb1fcce5444843e46e3e0f8e288efeda0116d84c98c104f55fbfadf";
    };
    "SWR2" = {
	    pskRaw = "8f204684620bb1739b2535e91e11216a88e1075ce07a8a56d5c6c6088cd05b97";
    };
    "HUB" = {
	    pskRaw = "cee96167f2a4e92a0588b6055483f76ac980c005a345a886e3ceaa6f020c15ff";
    };
    "EspressoGuests" = {
   	  pskRaw = "bf5adb74626711019a31f2e47f1babf98dcccbc4e987d3c266ace7ea9ea3ae0e";
    };
    "Excellence" = {
    	pskRaw = "e751221d62e9fa740710e50f5152a39288f497819f26c9af086257469b9d2829";
    };
    "FZI-PRIVATE-DEVICES" = {
      auth = ''
        key_mgmt=WPA-EAP
        identity="petricev"
        password=hash:4db5ccc75eb1bc29cd92e41e9f762136
      '';
    };
  };
}
