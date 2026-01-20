{ config, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    host = "0.0.0.0";
    port = 11434;
    syncModels = true;
    loadModels = [
      "qwen3-coder:30b"
    ];
  };
  networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [
    config.services.ollama.port
  ];
}
