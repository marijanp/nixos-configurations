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
    settings = {
      theme = "system";
      autoshare = false;
      autoupdate = true;
      plugin = [ "opencode-antigravity-auth@beta" ];
      model = "ollama/qwen3-coder-next";
      provider = {
        opencode = {
          options.apiKey = "{file:${osConfig.sops.secrets.opencode-zen-api-key.path}}";
        };
        ollama = {
          # The /v1 suffix is required by OpenCode for OpenAI-compatible APIs
          options.baseURL = "http://10.100.0.3:11434/v1";
          models = {
            "qwen3-coder-next" = {
              id = "qwen3-coder-next:q4_K_M";
              name = "Qwen 3 Coder Next (RTX 4090)";
              limit = {
                context = 65536;
                output = 16384;
              };
              prompt = "default";
              options = {
                temperature = 1.0;
                top_p = 0.95;
                top_k = 40;
                min_p = 0.01;
                repeat_penalty = 1.0;
              };
            };
          };
        };
        google = {
          models = {
            antigravity-gemini-3-pro = {
              id = "gemini-3-pro";
              name = "Gemini 3 Pro (Antigravity)";
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
              variants = {
                low = {
                  thinkingLevel = "low";
                };
                high = {
                  thinkingLevel = "high";
                };
              };
            };
            antigravity-gemini-3-flash = {
              id = "gemini-3-flash";
              name = "Gemini 3 Flash (Antigravity)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
              variants = {
                minimal = {
                  thinkingLevel = "minimal";
                };
                low = {
                  thinkingLevel = "low";
                };
                medium = {
                  thinkingLevel = "medium";
                };
                high = {
                  thinkingLevel = "high";
                };
              };
            };
          };
        };
      };
    };
  };
}
