{ config, pkgs, lib, osConfig, ... }:
{
  imports = [
    ./common.nix
    ./email.nix
  ];

  gtk = {
    enable = true;
    font.name = "Roboto";
    font.size = 10;
    theme = {
      package = pkgs.nordic;
      name = "Nordic-darker";
    };
    iconTheme = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Paper";
    package = pkgs.paper-icon-theme;
    size = 24;
  };

  programs.kitty = {
    enable = true;
    font.name = "Roboto Mono";
    font.size = 10;
    themeFile = "Nord";
    shellIntegration.enableBashIntegration = true;
  };

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "river";
    XDG_CURRENT_DESKTOP = "river";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  wayland.windowManager.river = {
    enable = true;
    package = pkgs.river-classic;
    systemd.enable = true;
    systemd.extraCommands = [
      "systemctl --user stop river-session.target"
      "systemctl --user start river-session.target"
      "systemctl --user start swayidle.target"
    ];
    extraSessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
    };
    settings = import ./river/settings.nix {
      inherit lib;
      isLaptop = osConfig.networking.hostName == "splitpad";
    };
  };

  programs.waybar = {
    enable = config.wayland.windowManager.river.enable;
    settings = import ./waybar/settings.nix {
      inherit lib;
      isLaptop = osConfig.networking.hostName == "splitpad";
    };
    style = lib.readFile ./waybar/style.css;
  };

  services.swayidle =
    let
      lockCmd = "${lib.getExe pkgs.waylock} -fork-on-lock -init-color 0x2e3440 -input-color 0x5e81ac -input-alt-color 0x81a1c1 -fail-color 0xbf616a";
    in
    {
      enable = true;
      events = [
        { event = "before-sleep"; command = lockCmd; }
        { event = "lock"; command = lockCmd; }
      ];
      timeouts = [
        { timeout = 3 * 60; command = lockCmd; }
        { timeout = 5 * 60; command = "${pkgs.systemd}/bin/systemctl suspend"; }
      ];
    };

  services.mako = {
    enable = true;
    settings = {
      font = "Roboto Mono 10";
      icon-path = "${pkgs.paper-icon-theme}/share/icons/Paper";
      max-icon-size = 32;
      text-color = "#d8dee9";
      background-color = "#2e3440";
      progress-color = "#4c566a";
      default-timeout = 8 * 1000;
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";
    font = "Roboto Mono 10";
    theme = ./rofi/nord.rasi;
  };

  # see https://github.com/nix-community/nix-direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.smos = {
    enable = true;
    workflowDir = "${config.home.homeDirectory}/smos-workflow";
    backup.enable = true;
    config = {
      calendar = {
        sources = [
          {
            name = "Google";
            destination = "calendar/google.smos";
            source-file = osConfig.age.secrets.smos-google-calendar-source.path;
          }
          {
            name = "platonic";
            destination = "calendar/platonic-google.smos";
            source-file = osConfig.age.secrets.smos-platonic-google-calendar-source.path;
          }
        ];
      };
      sync = {
        username = "marijan";
        password-file = osConfig.age.secrets.smos-sync-password.path;
        server-url = "api.smos.online";
      };
    };
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
        "browser.ml.chat.enabled" = false;
        "layout.css.grid-template-masonry-value.enabled" = true;
        "network.http.http2.websockets" = false; # firefox bug https://bugzilla.mozilla.org/show_bug.cgi?id=1655372
        # Fully disable Pocket. See
        # https://www.reddit.com/r/linux/comments/zabm2a.
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "0.0.0.0";
        "extensions.pocket.loggedOutVariant" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.onSaveRecs" = false;
        "extensions.pocket.onSaveRecs.locales" = "";
        "extensions.pocket.showHome" = false;
        "extensions.pocket.site" = "0.0.0.0";
        "browser.newtabpage.activity-stream.pocketCta" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        gopass-bridge
        #nordvpn-proxy
      ];
    };
  };

  home.packages =
    with pkgs; [
      agenix
      age-plugin-yubikey
      cachix
      cryptsetup
      dino
      element-desktop
      gopass
      gopass-jsonapi
      hledger
      mumble
      nix-tree
      nix-diff
      obsidian
      # obs-studio
      pavucontrol
      rclone
      steam
      signal-desktop-bin
      upterm
      watchexec
    ] ++ lib.optionals (config.wayland.windowManager.river.enable) [
      wlr-randr
      wdisplays # wayland arandr equivalent
      wl-clipboard
      rivercarro
      waylock
      brightnessctl
      pamixer
      optipng
      slurp
      grim
    ];
}
