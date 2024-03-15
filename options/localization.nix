{ config, pkgs, lib, ... }:
{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Zagreb";
  # List available options timedatectl list-timezones
}
