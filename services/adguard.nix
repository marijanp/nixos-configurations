{ config, ... }:
{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      dns = {
        ratelimit = 0;
        upstream_dns = config.networking.nameservers;
        # Bootstrap resolvers (used to resolve DNS over HTTPS/ DNS over TLS upstreams)
        bootstrap_dns = [ ] ++ config.networking.nameservers;
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
