{ pkgs, lib, agenix, hostName, ... }:
{

  programs.bash = {
    enable = true;
    shellAliases = {
      switch-yubi = ''gpg-connect-agent "scd serialno" "learn --force" /bye'';
      lg = "lazygit";
    } //
    lib.optionalAttrs (hostName == "splitpad") (
      let
        roamAddress = "F0:F6:C1:30:24:FA";
        airpodsAddress = "7C:C1:80:4F:7D:85";
      in
      {
        connect-airpods = "bluetoothctl connect ${airpodsAddress}";
        disconnect-airpods = "bluetootctl disconnect ${airpodsAddress}";
        connect-roam = "bluetoothctl connect ${roamAddress}";
        disconnect-roam = "bluetoothctl disconnect ${roamAddress}";
      }
    );
    profileExtra = ''
      export PS1="📅 \d ⌚️ \A\n\[\e[36m\]\u@\H\[\e[m\] [\w]\$ "
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

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./.vimrc;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-lspconfig
      vim-airline
    ];
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./.vimrc;
  };

  home.file.".vim/coc-setings.json".source = ./coc-settings.json;

  home.packages = with pkgs; [
    agenix.defaultPackage.${pkgs.system}
    curl
    gnupg
    lazygit
    tmate
    unzip
    wget
    zip
  ];
}
