{ config, ... }:
let
  hostName = config.networking.hostName;
  splitLocalIp = "192.168.1.3";
in
{
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = false;

    virtualHosts."adguard.${hostName}.wg" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass =
        "http://${config.services.adguardhome.host}:${toString config.services.adguardhome.port}";
    };
    virtualHosts."adguard.${hostName}.lan" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass =
        "http://${config.services.adguardhome.host}:${toString config.services.adguardhome.port}";
    };

    virtualHosts."ai.${hostName}.wg" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass = "http://split.wg:4000";
    };
    virtualHosts."ai.${hostName}.lan" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass = "http://${splitLocalIp}:4000";
    };

    virtualHosts."sync.${hostName}.wg" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass = "http://${config.services.syncthing.guiAddress}";
    };
    virtualHosts."sync.${hostName}.lan" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass = "http://${config.services.syncthing.guiAddress}";
    };

    virtualHosts."media.${hostName}.wg" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass = "http://127.0.0.1:8096";
    };
    virtualHosts."media.${hostName}.lan" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass = "http://127.0.0.1:8096";
    };

    virtualHosts."3d.${hostName}.wg" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass = "http://${splitLocalIp}";
      locations."/".proxyWebsockets = true;
    };
    virtualHosts."3d.${hostName}.lan" = {
      forceSSL = false;
      enableACME = false;
      locations."/".proxyPass = "http://${splitLocalIp}";
      locations."/".proxyWebsockets = true;
    };

    virtualHosts."zeroclaw.${hostName}.wg" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://${splitLocalIp}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host "zeroclaw.split.wg";
        '';
      };
    };
    virtualHosts."zeroclaw.${hostName}.lan" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://${splitLocalIp}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host "zeroclaw.split.wg";
        '';
      };
    };
  };
}
