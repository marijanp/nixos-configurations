{ pkgs,  ... }:
{
  options.programs.gnupg.agent = {
    enable = true;
    defaultPinentryFlavor = "curses";
  };
}