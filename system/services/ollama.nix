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
    environmentVariables = {
      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";
    };
  };
  networking.firewall.allowedTCPPorts = [
    config.services.ollama.port
  ];
}
