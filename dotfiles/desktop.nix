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
    enableGitIntegration = true;
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
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d/";
  };

  wayland.windowManager.river = {
    enable = true;
    package = pkgs.river-classic;
    systemd.enable = true;
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
        { timeout = 5 * 60; command = lockCmd; }
        { timeout = 8 * 60; command = "${pkgs.systemd}/bin/systemctl suspend"; }
      ];
    };

  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    systemdTarget = "river-session.target";
    settings = {
      verbosity = "INFO";
      media_minimum_duration = 10;
      idle_inhibitor = "wayland";
    };
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
      default-timeout = 5 * 1000;
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

  xdg.desktopEntries.firefox = {
      name = "Firefox";
      exec = "${lib.getExe config.programs.firefox.package} %U";
      mimeType = [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      categories = [ "Network" "WebBrowser" ];
      terminal = false;
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
        sponsorblock
        gopass-bridge
      ];
    };
  };

  home.packages =
    with pkgs; [
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
      signal-desktop-bin
      upterm
      watchexec
    ] ++ lib.optionals (config.wayland.windowManager.river.enable) [
      wlr-randr
      wdisplays # wayland arandr equivalent
      wl-mirror
      wl-clipboard
      rivercarro
      waylock
      brightnessctl
      optipng
      slurp
      grim
    ];
}
