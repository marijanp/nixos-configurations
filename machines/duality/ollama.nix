{ config, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    host = "127.0.0.1";
    port = 11434;
    syncModels = true;
    loadModels = [
      "qwen3-coder-next:q4_K_M"
      "qwen3.6:27b-q4_K_M"
    ];
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "30m"; # keeps the model loaded
      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_CONTEXT_LENGTH = "131072";
    };
  };
  networking.firewall.allowedTCPPorts = [
    config.services.ollama.port
  ];
}
