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
      "lambda".pskRaw = "0d0d8d97b38341789cd449e0ab875d75fa78a53d1648037229859f4e1cfe24e9";
      "WLAN-574446".pskRaw = "ca0f1467dbc64525d536fd4bc1dd36361868d3c72a2c51a6b043ab1520e38270";
      "Bava Bar".pskRaw = "41ee6cf3cd5b0a02accecf96b70d8f77e8489d4d209cdb5fc8ab6adf482ca9d5";
      "splitphone".pskRaw = "50755fc77ecca5e6755ca36b813f0336dcea4e82b54d92b3d76bf542960093f3";
      "Trafo Hub Member".pskRaw = "c64e25841b9a85ad818b9dfea5ec436826dd6efda1d95e27119c0f32449bdc5b";
      "jongenet".pskRaw = "15f1efca85bd2f654d649cea6f568ded74cb70cc2700c30a49827b45ec9328e3";
      "FRITZ!Box 7530 RR".pskRaw = "8a6f022cf4b922d938f4ea579a53f6512809897ced4f2585bf42f3c02112a293";
      "scaleUp_guests".pskRaw = "5cfd8d6e48fac65c744ab7baf6764fa03d8f6f885b8bbf8e0a137af98a4e3c4f";
      "MarriottBonvoy_Guest" = { };
      "citizenM" = { };
      "UCSB Wireless Web" = { };
      "Stanford Visitor" = { };
      "HOTEL BB" = { };
      "Starbucks WiFi" = { };
      "_Free JFK WiFi" = { };
      "_BER Airport Free Wi-Fi" = { };
      "Jadrolinija Free WiFi" = { };
      "WIFIonICE" = { };
    };
  };
}
