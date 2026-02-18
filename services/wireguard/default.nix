{ config, ... }:
{
  networking.wireguard.interfaces.wg0 = {
    privateKeyFile = config.sops.secrets.wg-private-key.path;
    peers = [
      {
        publicKey = builtins.readFile ./keys/epilentio-infrastructure.pub;
        allowedIPs = [
          "10.100.0.0/24"
          "fd10:100::/64"
        ];
        endpoint = "188.245.181.98:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
