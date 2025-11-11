{ pkgs, ... }:
{
  imports = [
    ../../dotfiles/common.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "marijan";
    homeDirectory = "/Users/marijan";
    packages = with pkgs; [
      roboto
      roboto-mono
      noto-fonts-color-emoji
    ];
  };

  programs.bash.bashrcExtra = ''
    PS1="\[\e[36m\]\u@\H\[\e[m\] | 📅 \d ⌚️ \A\n[\w]\$ "
  '';

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Roboto" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Roboto Mono" ];
        emoji = [ "Noto Color Emoji" "Noto Emoji" ];
      };
    };
  };

}
