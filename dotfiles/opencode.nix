{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  programs.opencode = {
    enable = true;
    tui = {
      theme = "system";
    };
    enableMcpIntegration = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoshare = false;
      autoupdate = false;
      mcp = {
        nixos = {
          type = "local";
          command = [ (lib.getExe pkgs.mcp-nixos) ];
          enabled = true;
        };
        github = {
          type = "local";
          command = [
            (lib.getExe pkgs.github-mcp-server)
            "stdio"
          ];
          environment.GITHUB_PERSONAL_ACCESS_TOKEN = "{file:${osConfig.sops.secrets.gh-mcp-token.path}}";
          enabled = true;
        };
      };
      model = "ollama-duality/qwen3-coder-next:q4_K_M";
      provider = {
        opencode = {
          options.apiKey = "{file:${osConfig.sops.secrets.opencode-zen-api-key.path}}";
        };
        ollama-duality = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama on Ryzen AI MAX";
          # The /v1 suffix is required by OpenCode for OpenAI-compatible APIs.
          options.baseURL = "http://127.0.0.1:11434/v1/";
          models = {
            "qwen3.6-27b-q4" = {
              id = "qwen3.6:27b-q4_K_M";
              name = "Qwen3.6 27B Q4_K_M";
              limit = {
                context = 65536;
                output = 8192;
              };
              prompt = "default";
              options = {
                temperature = 0.05;
                top_p = 0.95;
                top_k = 40;
                min_p = 0.05;
                repeat_penalty = 1.05;
              };
            };
            "qwen3-coder-next:q4_K_M" = {
              id = "qwen3-coder-next:q4_K_M";
              name = "Qwen3 Coder Next";
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
        ollama-split = {
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
