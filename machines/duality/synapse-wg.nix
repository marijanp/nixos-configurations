{ config, ... }:
{
  systemd.services.wireguard-synapse = {
    wants = [ "sops-install-secrets.service" ];
    after = [ "sops-install-secrets.service" ];
  };

  sops.secrets.synapse-wg-config = {
    sopsFile = ../../secrets/synapse-wg.conf;
    format = "binary";
  };

  networking.wg-quick.interfaces.synapse = {
    configFile = config.sops.secrets.synapse-wg-config.path;
    autostart = true;
  };
}
