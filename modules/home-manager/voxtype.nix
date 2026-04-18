{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.voxtype;
  voxtype = lib.getExe cfg.package;
  toml = pkgs.formats.toml { };

  systemdTarget =
    if config.wayland.windowManager.river.enable then "river-session.target" else "default.target";

  riverModifiers =
    if cfg.hotkey.modifiers == [ ] then
      "None"
    else
      lib.concatStringsSep "+" cfg.hotkey.modifiers;

  riverKey = "${riverModifiers} ${cfg.hotkey.key}";
  recordStart = "'${voxtype} record start'";
  recordStop = "'${voxtype} record stop'";
  recordToggle = "'${voxtype} record toggle'";
  recordCancel = "'${voxtype} record cancel'";

  hotkeyMode =
    if cfg.hotkey.mode == "pushToTalk" then
      "push_to_talk"
    else
      "toggle";

  generatedSettings = lib.recursiveUpdate {
    state_file = "auto";
    hotkey = {
      enabled = cfg.hotkey.enable && cfg.hotkey.backend == "evdev";
      key = cfg.hotkey.key;
      modifiers = cfg.hotkey.modifiers;
      mode = hotkeyMode;
    };
  } (
    lib.optionalAttrs (
      cfg.hotkey.enable
      && cfg.hotkey.backend == "compositor"
      && cfg.hotkey.compositor == "river"
      && cfg.hotkey.riverIntegration
    ) {
      output = {
        pre_recording_command = "riverctl enter-mode voxtype_recording";
        pre_output_command = "riverctl enter-mode voxtype_suppress";
        post_output_command = "riverctl enter-mode normal";
      };
    }
  );

  settings = lib.recursiveUpdate generatedSettings cfg.settings;

  modelLoaderScript = pkgs.writeShellScript "voxtype-model-loader" ''
    set -eu
    ${lib.concatMapStringsSep "\n" (
      model:
      "${voxtype} setup --download --model ${lib.escapeShellArg model} --quiet --no-post-install"
    ) cfg.loadModels}
  '';
in
{
  options.services.voxtype = {
    enable = lib.mkEnableOption "Voxtype push-to-talk voice transcription";

    package = lib.mkPackageOption pkgs "voxtype" {
      example = "pkgs.voxtype-vulkan";
    };

    settings = lib.mkOption {
      type = toml.type;
      default = { };
      example = {
        whisper = {
          model = "base.en";
          language = "en";
        };
        output = {
          mode = "type";
          fallback_to_clipboard = true;
        };
      };
      description = ''
        Voxtype configuration written to
        {file}`$XDG_CONFIG_HOME/voxtype/config.toml`.
      '';
    };

    extraArgs = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--verbose" ];
      description = "Extra command-line arguments passed to `voxtype daemon`.";
    };

    environment = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        VOXTYPE_WHISPER_API_KEY = "op://Personal/voxtype/api-key";
      };
      description = "Environment variables for the Voxtype user service.";
    };

    loadModels = lib.mkOption {
      type = types.listOf types.str;
      apply = builtins.filter (model: model != "");
      default = [ ];
      example = [
        "base.en"
        "large-v3-turbo"
      ];
      description = ''
        Download these models with `voxtype setup --download` before starting
        the daemon.
      '';
    };

    hotkey = {
      enable = lib.mkEnableOption "Voxtype hotkey integration" // {
        default = true;
      };

      backend = lib.mkOption {
        type = types.enum [
          "compositor"
          "evdev"
          "none"
        ];
        default = "compositor";
        description = ''
          Hotkey backend. The compositor backend is preferred on Wayland
          because it avoids `input` group membership.
        '';
      };

      compositor = lib.mkOption {
        type = types.enum [ "river" ];
        default = "river";
        description = "Compositor to configure when using compositor hotkeys.";
      };

      key = lib.mkOption {
        type = types.str;
        default = "V";
        example = "F9";
        description = "Key used for recording.";
      };

      modifiers = lib.mkOption {
        type = types.listOf types.str;
        default = [ "Super" ];
        example = [ ];
        description = ''
          Modifier keys for compositor hotkeys. Use an empty list for an
          unmodified key such as `F9`.
        '';
      };

      mode = lib.mkOption {
        type = types.enum [
          "pushToTalk"
          "toggle"
        ];
        default = "pushToTalk";
        description = "Recording mode for the configured hotkey.";
      };

      cancelKey = lib.mkOption {
        type = types.str;
        default = "F12";
        description = "Key used to cancel recording while Voxtype's River mode is active.";
      };

      riverIntegration = lib.mkOption {
        type = types.bool;
        default = true;
        description = ''
          Add River modes and Voxtype output hooks that prevent held modifier
          keys from turning transcribed text into compositor shortcuts.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.hotkey.enable && cfg.hotkey.backend == "compositor")
          || cfg.hotkey.compositor == "river";
        message = "services.voxtype.hotkey currently supports only the River compositor backend.";
      }
      {
        assertion = !(cfg.hotkey.enable && cfg.hotkey.backend == "compositor")
          || config.wayland.windowManager.river.enable;
        message = "services.voxtype.hotkey.backend = \"compositor\" requires wayland.windowManager.river.enable.";
      }
    ];

    home.packages = [ cfg.package ];

    xdg.configFile."voxtype/config.toml".source = toml.generate "voxtype-config.toml" settings;

    systemd.user.services.voxtype = {
      Unit = {
        Description = "Voxtype push-to-talk voice transcription";
        PartOf = [ systemdTarget ];
      }
      // lib.optionalAttrs (cfg.loadModels != [ ]) {
        Wants = [ "voxtype-model-loader.service" ];
        After = [ "voxtype-model-loader.service" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${voxtype} daemon ${lib.escapeShellArgs cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = lib.mapAttrsToList (name: value: "${name}=${value}") cfg.environment;
      };

      Install.WantedBy = [ systemdTarget ];
    };

    systemd.user.services.voxtype-model-loader = lib.mkIf (cfg.loadModels != [ ]) {
      Unit = {
        Description = "Download Voxtype models";
        Before = [ "voxtype.service" ];
        Wants = [ "network-online.target" ];
        After = [ "network-online.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = modelLoaderScript;
        Restart = "on-failure";
        RestartSec = "30s";
      };

      Install.WantedBy = [ systemdTarget ];
    };

    wayland.windowManager.river.settings = lib.mkIf (
      cfg.hotkey.enable && cfg.hotkey.backend == "compositor" && cfg.hotkey.compositor == "river"
    ) (
      lib.mkMerge [
        {
          map.normal.${riverKey}.spawn =
            if cfg.hotkey.mode == "pushToTalk" then recordStart else recordToggle;
        }
        (lib.mkIf (cfg.hotkey.mode == "pushToTalk") {
          map-release.normal.${riverKey}.spawn = recordStop;
        })
        (lib.mkIf cfg.hotkey.riverIntegration {
          declare-mode = [
            "voxtype_recording"
            "voxtype_suppress"
          ];
          map = {
            voxtype_recording."None ${cfg.hotkey.cancelKey}" = [
              { spawn = recordCancel; }
              "enter-mode normal"
            ];
            voxtype_suppress = {
              "None Super_L".spawn = "true";
              "None Super_R".spawn = "true";
              "None Control_L".spawn = "true";
              "None Control_R".spawn = "true";
              "None Alt_L".spawn = "true";
              "None Alt_R".spawn = "true";
              "None Shift_L".spawn = "true";
              "None Shift_R".spawn = "true";
              "None ${cfg.hotkey.cancelKey}" = "enter-mode normal";
            };
          };
          map-release = lib.mkIf (cfg.hotkey.mode == "pushToTalk") {
            voxtype_recording.${riverKey} = [
              { spawn = recordStop; }
              "enter-mode normal"
            ];
          };
        })
      ]
    );
  };
}
