{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.zeroclaw-xmpp-bridge;
in
{

  options.services.zeroclaw-xmpp-bridge = {

    enable = lib.mkEnableOption "ZeroClaw XMPP/OMEMO bridge";

    package = lib.mkPackageOption pkgs "zeroclaw-xmpp-bridge" { };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host the bridge binds to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5000;
      description = "Port the bridge binds to.";
    };

    jid = lib.mkOption {
      type = lib.types.str;
      example = "bot@example.com";
      description = "XMPP JID for the bridge bot.";
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = "Env file containing XMPP_PASSWORD=<secret>.";
      example = "/run/secrets/xmpp-bridge-password";
    };

    zeroclawUrl = lib.mkOption {
      type = lib.types.str;
      example = "http://127.0.0.1:8080/webhook";
      description = "URL the bridge forwards incoming XMPP messages to.";
    };

    allowedJids = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "*" ];
      example = [ "alice@example.com" ];
      description = "Allowed sender bare JIDs, or [\"*\"] for everyone.";
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.zeroclaw-xmpp-bridge = {
      description = "ZeroClaw XMPP/OMEMO bridge";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        XMPP_JID = cfg.jid;
        ZEROCLAW_URL = cfg.zeroclawUrl;
        LISTEN_HOST = cfg.host;
        LISTEN_PORT = toString cfg.port;
        ALLOWED_JIDS = lib.concatStringsSep "," cfg.allowedJids;
        DATA_DIR = "/var/lib/zeroclaw-xmpp-bridge";
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/zeroclaw-xmpp-bridge";
        EnvironmentFile = cfg.passwordFile;
        Restart = "on-failure";
        RestartSec = "10s";
        StateDirectory = "zeroclaw-xmpp-bridge";
        StateDirectoryMode = "0700";
        DynamicUser = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
      };
    };

  };

}
