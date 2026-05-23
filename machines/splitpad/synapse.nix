{ config, ... }:
{
  systemd.services.wireguard-synapse = {
    wants = [ "sops-install-secrets.service" ];
    after = [ "sops-install-secrets.service" ];
  };

  sops.secrets.synapse-splitpad-wg-config = {
    sopsFile = ../../secrets/synapse-splitpad-wg.conf;
    format = "binary";
  };

  networking.wg-quick.interfaces.synapse = {
    configFile = config.sops.secrets.synapse-splitpad-wg-config.path;
    autostart = true;
  };
}
