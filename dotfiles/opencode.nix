{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    lib.optionals (config.programs.opencode.enable) [
      lsof
    ];

  programs.opencode = {
    enable = true;
    tui = {
      theme = "system";
    };
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoshare = false;
      autoupdate = false;
      model = "ollama/qwen3.6-27b-mtp-q4";
      provider = {
        opencode = {
          options.apiKey = "{file:${osConfig.sops.secrets.opencode-zen-api-key.path}}";
        };
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama on RTX 4090";
          # The /v1 suffix is required by OpenCode for OpenAI-compatible APIs.
          options.baseURL = "http://10.100.0.3:11434/v1/";
          models = {
            "qwen3.6-35b-a3b-q4" = {
              id = "qwen3.6:35b-a3b-q4_K_M";
              name = "Qwen 3.6 35B A3B Q4_K_M";
              limit = {
                context = 65536;
                output = 8192;
              };
              prompt = "default";
              options = {
                temperature = 0.1;
                top_p = 0.95;
                top_k = 40;
                min_p = 0.05;
                repeat_penalty = 1.05;
              };
            };
            "qwen3.6-27b-mtp-q4" = {
              id = "qwen3.6:27b-mtp-q4_K_M";
              name = "Qwen 3.6 27B MTP Q4_K_M";

              limit = {
                context = 65536;
                output = 8192;
              };
              prompt = "default";
              options = {
                temperature = 0.1;
                top_p = 0.95;
                top_k = 40;
                min_p = 0.05;
                repeat_penalty = 1.05;
              };
            };
          };
        };
      };
    };
  };
}
