files:
let
  link = origin: target: "L+ ${target} - - - - ${origin}";
  home = "/home/marijan/";
in
{
  systemd.tmpfiles.rules = map ({ origin, target }: link origin "${home}${target}") files;
}
