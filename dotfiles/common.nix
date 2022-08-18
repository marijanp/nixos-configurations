{ pkgs, ... }:
{

  programs.bash = {
    enable = true;
    shellAliases = {
      switch-yubi = ''gpg-connect-agent "scd serialno" "learn --force" /bye'';
    };
    profileExtra = ''
      export PS1="📅 \d ⌚️ \A\n\[\e[36m\]\u@\H\[\e[m\] [\w]\$ "
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

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./.vimrc;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    curl
    gnupg
    lazygit
    tmate
    unzip
    wget
    zip
    # fonts
    roboto-mono
  ];
}
