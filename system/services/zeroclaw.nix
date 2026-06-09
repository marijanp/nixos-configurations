{ config, ... }:
let
  zeroclawWebhookPort = 42618;
in
{
  users.groups.zeroclaw-instruct = { };
  users.users.marijan.extraGroups = [ "zeroclaw-instruct" ];

  users.groups.zeroclaw-secrets = { };
  sops.secrets.telegram-bot-token = {
    group = "zeroclaw-secrets";
    mode = "0440";
  };
  sops.secrets.xmpp-bridge-password = { };

  networking.firewall.allowedTCPPorts = [ config.services.zeroclaw.port ];

  services.zeroclaw-xmpp-bridge = {
    enable = true;
    jid = "tovar@chat.marijan.pro";
    passwordFile = config.sops.secrets.xmpp-bridge-password.path;
    zeroclawUrl = "http://127.0.0.1:${toString zeroclawWebhookPort}/webhook";
    allowedJids = [ "marijan@chat.marijan.pro" ];
  };

  services.zeroclaw = {
    enable = true;
    host = "0.0.0.0";
    extraGroups = [
      "zeroclaw-secrets"
      "zeroclaw-instruct"
    ];

    channels.telegram.secretFiles.bot_token = config.sops.secrets.telegram-bot-token.path;

    settings = {
      default_provider = "ollama";
      default_model = "qwen3-coder-next:q4_K_M";
      api_url = "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
      channels_config.telegram = {
        allowed_users = [ "marijanp" ];
      };
      channels_config.webhook = {
        port = zeroclawWebhookPort;
        send_url = "http://${config.services.zeroclaw-xmpp-bridge.host}:${toString config.services.zeroclaw-xmpp-bridge.port}/send";
      };
      autonomy = {
        auto_approve = [
          "file_read"
          "memory_recall"
          "http_request"
          "web_fetch"
          "web_search"
          "cron_add"
          "cron_list"
          "cron_remove"
          "cron_update"
          "cron_run"
        ];
        non_cli_excluded_tools = [
        ];
      };
      http_request.enabled = true;
      web_fetch = {
        enabled = true;
        allowed_domains = [
          "reuters.com"
          "bloomberg.com"
          "finance.yahoo.com"
          "seekingalpha.com"
          "marketwatch.com"
          "cnbc.com"
          "ft.com"
          "wsj.com"
          "discourse.nixos.org"
          "github.com"
        ];
      };
      web_search.enabled = true;
      cron.jobs = [
        {
          id = "daily-stock-briefing";
          name = "Daily Stock Briefing";
          job_type = "agent";
          schedule = {
            kind = "cron";
            expr = "00 14 * * MON-FRI";
            tz = "Europe/Berlin";
          };
          prompt = ''
            You are a senior Wall Street equity research analyst and a senior Swiss asset and wealth manager with deep expertise in value and growth investing.
            Your task is to deliver a concise, actionable briefing, only covering developments from the past 24 hours.

            Tone: Professional, decisive, no filler. Use short paragraphs and bullet points where helpful — but avoid markdown.
            Strict deadline enforcement: Ignore all data older than 24 hours. If uncertain, say: No new information since [date/time].

            Instructions:
            1. Start with a macro and market overview (1–2 paragraphs max):
               - Key global indices (S&P 500, Nasdaq, etc.): % changes, volume, notable leaders/laggards
               - Major FX moves (EUR/USD, EUR/CHF etc.)
               - Commodity highlights (crude oil, copper, etc.)
               - Central bank commentary or policy shifts (Fed, ECB)
               - Only include events from the past 24 hours

            2. Then for each stock ticker in this list: MELI, GOOGL, AMZN, ASML, BKNG, MA, TSM, CRM, UBER, MC, NVO, DUOL, META, OPRA - you will send me a message
               containing the following information:

            2.1. Recent news overview:
               - Only cover news/events published or materialized in the last 24 hours
               - Prefer serious news sources like Reuters, Bloomberg, etc.
               - If there are no news, say: No new information since [date/time].
               - For each event:
                 * Source and time (e.g., JPMorgan downgrade, Mar 12, 10:15 UTC, <link to source>)
                 * Impact severity: High / Medium / Low
                 * Why it matters: one sentence describing the strategic implication for a value or growth investor
               - Do not rehash earnings or data older than 24 hours - only new catalysts, analyst moves, regulatory updates, or operational milestones

            2.2. End with a 1–2 sentence actionable takeaway per stock:
               - How this affects your valuation thesis
               - What to watch for in next 1–2 weeks
               - Any changes to near-term buy/hold/monitor status
               - Buy price
          '';
          enabled = true;
          delivery = {
            mode = "announce";
            channel = "telegram";
            to = "marijanp";
          };
        }
      ];
      observability.backend = "prometheus";
    };
  };
}
