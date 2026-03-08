{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    # when having scaling issues with compositor
    # gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
