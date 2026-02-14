{ config, ... }:
let
  guiPort = 2000;
in
{
  users.users.marijan.extraGroups = [ config.services.syncthing.group ];
  systemd.tmpfiles.rules = [
    "d ${config.services.syncthing.dataDir} 0710 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
    "d ${config.services.syncthing.dataDir}/exchange 2770 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
    "L+ ${config.users.users.marijan.home}/exchange - ${config.users.users.marijan.name} ${config.users.users.marijan.group} - ${config.services.syncthing.dataDir}/exchange"
  ];
  services.syncthing = {
    enable = true;
    guiPasswordFile = config.sops.secrets.syncthing-password.path;
    guiAddress = "0.0.0.0:${toString guiPort}";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "splitpad".id = "H7JXADF-HDG634J-Y3HO5DP-FWO5NK7-NWJRBFA-EFY23AA-SLFNMKE-7PU2YQD";
        "splitberry".id = "EK4ME3H-QOS5Y4U-CMFNUVI-LBUNTKC-EATEETS-6M6LH2L-MVQWCVR-N53XZQG";
        "splitphone".id = "VKUIYXT-FMCXVB4-U3EV4ZC-G4ZJ4AY-WIFGUY6-45JQVF6-APDZAZS-5OESTA5";
      };
      folders = {
        "exchange" = {
          path = "${config.services.syncthing.dataDir}/exchange";
          type = "sendreceive";
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "10";
          };
          devices = [
            "splitpad"
            "splitberry"
            "splitphone"
          ];
        };
      };
      options = {
        urAccepted = -1;
      };
      gui.user = "marijan";
    };
  };
  networking.firewall.interfaces."tailscale0".allowedUDPPorts = [
    22000 # transfers
    21027 # discovery
  ];
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    22000 # transfers
    guiPort
  ];
}
