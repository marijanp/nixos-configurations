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
      "Yo mamas iPhone".pskRaw = "027dc1b59db80540334b4b58d403c840ea6497296285045a1facb24b76105de2";
      "Trafo Hub Member".pskRaw = "c64e25841b9a85ad818b9dfea5ec436826dd6efda1d95e27119c0f32449bdc5b";
      "MarriottBonvoy_Guest" = { };
      "Starbucks WiFi" = { };
      "_Free JFK WiFi" = { };
      "_BER Airport Free Wi-Fi" = { };
      "WIFIonICE" = { };
    };
  };
}
