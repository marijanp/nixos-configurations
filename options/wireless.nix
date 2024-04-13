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
      "splitphone".pskRaw = "50755fc77ecca5e6755ca36b813f0336dcea4e82b54d92b3d76bf542960093f3";
      "Bava Bar".pskRaw = "41ee6cf3cd5b0a02accecf96b70d8f77e8489d4d209cdb5fc8ab6adf482ca9d5";
      "jongenet".pskRaw = "15f1efca85bd2f654d649cea6f568ded74cb70cc2700c30a49827b45ec9328e3";
      "GuestLowen".pskRaw = "cf8ceeb9cc60039b1799c666796782ff599819f094e234aa1763734ed881a9e0";
      "Boss Bude".pskRaw = "602d6b13bcb0d2287bf2a2770e2fa9697df08dd02f4e6e3019e23a25bbd542be";
      "Fachpraxis-Beyer".pskRaw = "074b90e2c6f3c4c1639534933fb97659cc79b53de52cc9a74111e305b26cc414";
      "KaffeeHaus".pskRaw = "532e0dbf1a81de593d2352a0cf72e54818246c48b53945c89beff4e23585863d";
      "HOTEL BB" = { };
      "WestfalenBahn" = { };
      "Jadrolinija Free WiFi" = { };
      "WIFIonICE" = { };
      "Starbucks WiFi" = { };
      "citizenM" = { };
      "CLIENTES URBANIA VIVA" = { };
      " GANSO Y CASTOR - CLIENTES" = { };
      "Pergamino Clientes" = { };
      "MOSAIKO STUDIO SAS jota".pskRaw = "edf024118a4d276734f46bd3d76ee67bb6b21f8431abd34bcaf333243b1f3a61";
      "Nomadas El Tesoro" = { };
    };
  };
}
