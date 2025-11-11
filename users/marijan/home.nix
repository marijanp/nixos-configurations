{ osConfig, ... }:
{
  home.username = "marijan";
  home.homeDirectory = "/home/marijan";
  home.stateVersion = osConfig.system.stateVersion;
  home.preferXdgDirectories = true;
}
