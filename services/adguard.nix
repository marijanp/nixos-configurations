{ config, ... }:
{
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
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
    };
  };
}
