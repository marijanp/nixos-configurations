{ pkgs, lib, ... }:
let 
  codium-settings-path = ".config/VSCodium/User/settings.json";
in
{
  imports = [
    ./common.nix
  ];

  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Roboto Mono";
        size = 11;
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = ["cpu" "memory" "network" "bluetooth" "pulseaudio" "clock"];
        "cpu" = {
          format = "CPU {usage0}% {usage1}% {usage2}% {usage3}%";
        };
        "memory" = {
          format = "RAM {}%";
        };
        "network" = {
          format = "{essid} ⬆️{bandwidthUpBits}⬇️{bandwidthDownBits}";
        };
        "clock" = {
          format = "{:%Y-%m-%d %H:%M}";
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "🔇 {volume}%";
          format-icons = {
            default = ["🔈" "🔉" "🔊"];
          };
        };
      };
    };
    style = ./waybar.css;
  };

  # Block auto-sway reload, Sway crashes if allowed to reload this way.
  xdg.configFile."sway/config".onChange = lib.mkForce "";

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      terminal = "${pkgs.alacritty}/bin/alacritty";
      modifier = "Mod4";
      bars = [
        {
          command =  "${pkgs.waybar}/bin/waybar";
        }
      ];
      fonts = {
        names = [ "Roboto" "Roboto Mono" ];
        size = 11.0;
      };
      colors = {
        focused = { background = "#64FFDA"; border = "#64FFDA"; childBorder = "#285577"; indicator = "#2e9ef4"; text = "#ffffff"; };
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us+keypad(x11)";
          xkb_options = "eurosign:e";
        };
      };
      startup = [
        { always = true; command = "touch $SWAYSOCK.wob && tail -n0 -f $SWAYSOCK.wob | ${pkgs.wob}/bin/wob"; }
      ];
      keybindings = {
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5 && ${pkgs.light}/bin/light -G | cut -d'.' -f1 > $SWAYSOCK.wob";
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5 && ${pkgs.light}/bin/light -G | cut -d'.' -f1 > $SWAYSOCK.wob";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ui 2 && ${pkgs.pamixer}/bin/pamixer --get-volume > $SWAYSOCK.wob";
        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ud 2 && ${pkgs.pamixer}/bin/pamixer --get-volume > $SWAYSOCK.wob";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute && ( ${pkgs.pamixer}/bin/pamixer --get-mute && echo 0 > $SWAYSOCK.wob ) || ${pkgs.pamixer}/bin/pamixer --get-volume > $SWAYSOCK.wob";

        "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${modifier}+c" = "kill";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+r" = "mode resize";

        "${modifier}+d" = "exec ${pkgs.wofi}/bin/wofi --show run";
        "${modifier}+p" = "exec ${pkgs.firefox}/bin/firefox";
        "${modifier}+x" = "exec ${pkgs.swaylock}/bin/swaylock -c 325D79";

        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+space" = "floating toggle";
        "${modifier}+a" = "focus parent";
        "${modifier}+v" = "splitv";
        "${modifier}+b" = "splith";

        "${modifier}+e" =  "layout toggle split";
        "${modifier}+w" =  "layout tabbed";
        "${modifier}+s" = "layout stacking";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
      };
    };
  };

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
    # OZ_USE_XINPUT2 = "1";
     #WLR_DRM_NO_MODIFIERS = "1";
    SDL_VIDEODRIVER = "wayland";
    # QT_QPA_PLATFORM = "wayland";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  home.packages = with pkgs; [
    cachix
    element-desktop
    firefox
    gopass
    gopass-jsonapi
    hledger
    niv
    noto-fonts-emoji
    qemu
    roboto
    roboto-mono
    solaar
    thunderbird
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = (with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-vscode-remote.remote-ssh
      eamodio.gitlens
      zhuangtongfa.material-theme
      pkief.material-icon-theme
      jnoortheen.nix-ide
      haskell.haskell
      justusadam.language-haskell
      #llvm-vs-code-extensions.vscode-clangd
      #ms-python.python
      gruntfuggly.todo-tree
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "language-purescript";
        publisher = "nwolverson";
        version = "0.2.8";
        sha256 = "sha256-2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
      }
    ];
  };

  home.file.${codium-settings-path}.source = ./codium-settings.json;
}
