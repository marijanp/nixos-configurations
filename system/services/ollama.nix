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
  services.open-webui = {
    enable = config.services.ollama.enable;
    host = "0.0.0.0";
    port = 4000;
    environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
  };
  networking.firewall.allowedTCPPorts = [
    config.services.ollama.port
    config.services.open-webui.port
  ];
}
