{ config, osConfig, pkgs, lib, ... }:
{
  home.packages = with pkgs; lib.optionals (config.programs.opencode.enable) [
    lsof
  ];

  programs.opencode = {
    enable = true;
    settings = {
      theme = "system";
      autoshare = false;
      autoupdate = true;
      plugin = ["opencode-antigravity-auth@beta"];

      model = "opencode/grok-code";
      provider = {
        opencode = {
          options.apiKey = "{file:${osConfig.sops.secrets.opencode-zen-api-key.path}}";
        };
        ollama = {
          # The /v1 suffix is required by OpenCode for OpenAI-compatible APIs
          options.baseURL = "http://split:11434/v1";
          models = {
            "qwen3-coder" = {
              id = "qwen3-coder:30b";
              name = "Qwen 3 Coder 30b (RTX 4090)";
              limit = { context = 128000; output = 65536; };
              prompt = "default";
              options = {
                temperature = 0.0;
              };
            };
          };
        };
        google = {
          models = {
            antigravity-gemini-3-pro = {
              id = "gemini-3-pro";
              name = "Gemini 3 Pro (Antigravity)";
              limit = { context = 1048576; output = 65535; };
              modalities = { input = [ "text" "image" "pdf"]; output = ["text"]; };
              variants = {
                low = { thinkingLevel = "low"; };
                high = { thinkingLevel = "high"; };
              };
            };
            antigravity-gemini-3-flash = {
              id = "gemini-3-flash";
              name = "Gemini 3 Flash (Antigravity)";
              limit = { context = 1048576; output = 65536; };
              modalities = { input = ["text" "image" "pdf"]; output = ["text"]; };
              variants = {
                minimal = { thinkingLevel = "minimal"; };
                low = { thinkingLevel = "low"; };
                medium = { thinkingLevel = "medium"; };
                high = { thinkingLevel = "high"; };
              };
            };
          };
        };
      };
    };
  };
}
