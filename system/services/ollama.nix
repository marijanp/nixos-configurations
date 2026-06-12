{ config, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    host = "0.0.0.0";
    port = 11434;
    syncModels = true;
    loadModels = [
      "qwen3.6:27b-mtp-q4_K_M"
      "qwen3.6:35b-a3b-q4_K_M"
    ];
    environmentVariables = {
      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_CONTEXT_LENGTH = "65536";
    };
  };
  networking.firewall.allowedTCPPorts = [
    config.services.ollama.port
  ];
}
