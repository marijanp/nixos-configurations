{ config, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    host = "0.0.0.0";
    port = 11434;
    syncModels = true;
    loadModels = [
      "qwen3-coder-next:q4_K_M"
    ];
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [
    config.services.ollama.port
  ];
}
