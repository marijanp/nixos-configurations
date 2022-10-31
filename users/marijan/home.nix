{ pkgs, lib, osConfig, ... }:
{
  home.username = "marijan";
  home.homeDirectory = "/home/marijan";
  home.stateVersion = osConfig.system.stateVersion;
}
