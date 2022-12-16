{ pkgs, config, lib, agenix, osConfig, ... }:
{

  imports = [
    ./nvim
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      switch-yubi = ''gpg-connect-agent "scd serialno" "learn --force" /bye'';
      lg = "lazygit";
    } //
    lib.optionalAttrs (osConfig.networking.hostName == "splitpad") (
      let
        roamAddress = "F0:F6:C1:30:24:FA";
        airpodsAddress = "7C:C1:80:4F:7D:85";
      in
      {
        connect-airpods = "bluetoothctl connect ${airpodsAddress}";
        disconnect-airpods = "bluetoothctl disconnect ${airpodsAddress}";
        connect-roam = "bluetoothctl connect ${roamAddress}";
        disconnect-roam = "bluetoothctl disconnect ${roamAddress}";
      }
    );
    profileExtra = ''
      export PS1="\[\e[36m\]\u@\H\[\e[m\] | 📅 \d ⌚️ \A\n[\w]\$ "
    '';
  };

  home.file.".inputrc".text = ''
    "\e[A": history-search-backward
    "\e[B": history-search-forward
  '';

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    prefix = "C-s";
    resizeAmount = 50;
    customPaneNavigationAndResize = true;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.nord;
        extraConfig = ''set -g @plugin "arcticicestudio/nord-tmux"'';
      }
    ];
  };

  programs.git = {
    enable = true;
    userName = "Marijan Petričević";
    userEmail = "marijan.petricevic94@gmail.com";
    signing = {
      key = "0xEFF1AB41802F3FA7";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./vim/.vimrc;
  };

  programs.lazygit = {
    enable = true;
    package = (pkgs.lazygit.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          name = "fix-credential-prompt.patch";
          url = "https://patch-diff.githubusercontent.com/raw/jesseduffield/lazygit/pull/2239.patch";
          sha256 = "sha256-olj4xV1AU93R76drDuISQRNpxv/85GBfXJe6WgO33xc=";
        })
      ];
    }));
    settings = {
      git.autoFetch = false;
    };
  };

  home.packages = with pkgs; [
    agenix.defaultPackage.${pkgs.system}
    age-plugin-yubikey
    curl
    gnupg
    ripgrep
    tmate
    unzip
    wget
    zip
  ];
}
