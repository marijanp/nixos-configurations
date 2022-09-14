{ config, pkgs, ... }:

{
  networking.wireless = {
    enable = true; # Enables wireless support via wpa_supplicant.
    # wpa_cli
    # scan
    # scan_results
    # add_network
    # set_network 0 ssid "laganini"
    # set_network 0 psk "secret"
    # or set_network 0 key_mgmt NONE
    # enable_network 0
    userControlled.enable = true;
    networks = {
      "laganini".pskRaw = "6bca9bedd7841c7cc6269a477805c6d2493f6fcc654d451455c7600411238153";
      "WLAN-574446".pskRaw = "ca0f1467dbc64525d536fd4bc1dd36361868d3c72a2c51a6b043ab1520e38270";
      "Bava Bar".pskRaw = "41ee6cf3cd5b0a02accecf96b70d8f77e8489d4d209cdb5fc8ab6adf482ca9d5";
      "POBLADO PARK".pskRaw = "1f1facc940c4a4abc5c347b4abb0f319a56dcd629358fd4302be0a18aaad54b9";
      "Poblado Park II".pskRaw = "5d146bd0f1f56ba3d99b9eb5feed5470416a931171c7603b53a4b563f9839e16";
    };
  };
}
