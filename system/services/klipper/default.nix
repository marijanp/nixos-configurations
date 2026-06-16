{ config, lib, ... }:
{
  services.klipper = {
    enable = true;
    mutableConfig = true;
    inherit (config.services.moonraker) user group;
    configFile = ./printer.cfg;
    firmwares = {
      mcu = {
        enable = true;
        enableKlipperFlash = true;
        configFile = ./config; # Run klipper-genconf to generate this
        serial = "/dev/serial/by-id/usb-Klipper_stm32f407xx_230031001747393338363031-if00";
      };
    };
  };

  services.prometheus.exporters.klipper.enable = config.services.klipper.enable;
  networking.firewall.interfaces."wg0".allowedTCPPorts = [
    config.services.prometheus.exporters.klipper.port
  ];

  networking.firewall.allowedTCPPorts = [ 80 ];

  services.moonraker = {
    enable = config.services.klipper.enable;
    address = "0.0.0.0";
    port = 7125;
    settings = {
      file_manager.config_path = config.services.klipper.configDir;
      authorization = {
        cors_domains = [
          "http://split.lan:7125"
          "http://split.wg:7125"
          "http://split.local:7125"
          "http://3d.pneuma.wg"
          "http://3d.pneuma.lan"
        ];
        trusted_clients = [
          "127.0.0.1/32"
          "10.100.0.0/24" # wireguard
          "192.168.1.0/24" # local network (pneuma proxy)
          "fd7a:115c:a1e0::/64"
        ];
      };
    };
  };

  services.mainsail = {
    enable = config.services.moonraker.enable;
    hostName = "3d.pneuma.lan";
    nginx = {
      serverAliases = [
        "3d.pneuma.wg"
        "${config.networking.hostName}.local"
        "split.lan"
        "split.wg"
      ];
      locations."/websocket" = {
        proxyWebsockets = true;
        proxyPass = "http://mainsail-apiserver/websocket";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
      locations."~ ^/(printer|api|access|machine|server)/" = {
        proxyWebsockets = true;
        proxyPass = "http://mainsail-apiserver$request_uri";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
    }
    // lib.optionalAttrs config.services.ustreamer.enable {
      locations."/webcam/" = {
        proxyPass = "http://${config.services.ustreamer.listenAddress}/";
        extraConfig = ''
          postpone_output 0;
          proxy_buffering off;
          proxy_ignore_headers X-Accel-Buffering;
        '';
      };
    };
  };
}
