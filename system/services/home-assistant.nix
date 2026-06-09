{ config, ... }:
let
  port = 8123;
in
{
  services.home-assistant = {
    enable = true;
    config = {
      homeassistant = {
        name = "Pneuma";
        unit_system = "metric";
        time_zone = config.time.timeZone;
      };

      default_config = { };

      http = {
        server_host = "127.0.0.1";
        server_port = port;
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
    };
  };
}
