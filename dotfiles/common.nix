{ pkgs, config, lib, osConfig, ... }:
{

  imports = [
    ./nvim
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      switch-yubi = "gpg-connect-agent 'scd serialno' 'learn --force' /bye";
      nixcon = "sudo nixos-container";
      nrn = "nix repl --file '<nixpkgs>'";
    }
    // lib.optionalAttrs config.programs.lazygit.enable {
      lg = "lazygit";
    }
    // lib.optionalAttrs (pkgs.stdenv.isLinux && osConfig.hardware.bluetooth.enable) (
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
  };

  programs.readline = {
    enable = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
  };

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
      # remember and reuse resolved merge conflicts
      rerere.enabled = true;
      # shows the diff when writing a commit message
      commit.verbose = true;
      pull.rebase = true;
      rebase.updateRefs = true;
      # On push sets the remote automatically to avoid setting --set-upstream manually
      push.autoSetupRemote = true;
    };
  };

  programs.lazygit = {
    enable = config.programs.git.enable;
    settings = {
      git.autoFetch = false;
    };
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./vim/.vimrc;
  };

  home.packages = with pkgs; [
    curl
    jq
    niv
    npins
    nix-output-monitor
    ripgrep
    tree
    unzip
    zip
  ];
}
