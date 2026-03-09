{ config, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [
      53 # DNS
      853 # DNS over TLS
    ];
    allowedUDPPorts = [
      53 # DNS
      5353 # DNS over QUIC
    ];
  };

  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      dns = {
        ratelimit = 0;
        upstream_dns = [
          # quad9
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];
        bootstrap_dns = [
          # quad9
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];
      };
      statistics_interval = 30; # days
      querylog_enabled = true;
      refuse_any = true;
      filtering = {
        rewrites = [
          {
            domain = "epilentio-infrastructure.wg";
            answer = "10.100.0.1";
            enabled = true;
          }
          {
            domain = "epilentio-infrastructure.wg";
            answer = "fd10:100::1";
            enabled = true;
          }
          {
            domain = "splitpad.wg";
            answer = "10.100.0.2";
            enabled = true;
          }
          {
            domain = "splitpad.wg";
            answer = "fd10:100::2";
            enabled = true;
          }
          {
            domain = "split.wg";
            answer = "10.100.0.3";
            enabled = true;
          }
          {
            domain = "split.wg";
            answer = "fd10:100::3";
            enabled = true;
          }
          {
            domain = "splitphone.wg";
            answer = "10.100.0.4";
            enabled = true;
          }
          {
            domain = "splitphone.wg";
            answer = "fd10:100::4";
            enabled = true;
          }
          {
            domain = "splitberry.wg";
            answer = "10.100.0.5";
            enabled = true;
          }
          {
            domain = "splitberry.wg";
            answer = "fd10:100::5";
            enabled = true;
          }
          {
            domain = "split3d.wg";
            answer = "10.100.0.6";
            enabled = true;
          }
          {
            domain = "split3d.wg";
            answer = "fd10:100::6";
            enabled = true;
          }
        ];
      };
      user_rules = [
        "@@||halowaypoint.com^"
        "@@||playfabapi.com^"
        "@@||vortex.data.microsoft.com^"
      ];
    };
  };
}
