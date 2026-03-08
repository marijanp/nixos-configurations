{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      roboto
      roboto-mono
      noto-fonts-color-emoji
    ];
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        serif = [ "Roboto" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Roboto Mono" ];
        emoji = [
          "Noto Color Emoji"
          "Noto Emoji"
        ];
      };
      hinting = {
        enable = true;
        style = "medium";
      };
      subpixel = {
        rgba = "vrgb";
        lcdfilter = "none";
      };
    };
  };
}
