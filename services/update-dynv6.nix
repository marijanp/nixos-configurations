{config, pkgs, lib, ...}:

# in configuration.nix call
# imports = [
#     ./update-dynv6.nix
#   ];

{
  environment.systemPackages = [ pkgs.iproute pkgs.gnugrep pkgs.gnused pkgs.coreutils ];
  systemd = {
    timers.update-dynv6 = {
      description = "Timer for updating the AAAA record.";
      wantedBy = [ "basic.target" ];
      partOf = [ "update-dynv6.service" ];
      timerConfig.OnUnitActiveSec = "10m";
      timerConfig.OnActiveSec = "30s";
    };
    services.update-dynv6 = {
      description = "Updates the AAAA record.";
      script = ''
        #!${pkgs.stdenv.shell}
        hostname=split.dynv6.net
        device=eno1
        token=7BUQjDzK6wFbQg_84usUx7SEuvQSZz
        file=$HOME/.dynv6.addr6
        [ -e $file ] && old=`${pkgs.coreutils}/bin/cat $file`

        if [ -z "$hostname" -o -z "$token" ]; then
          ${pkgs.coreutils}/bin/echo "Usage: token=<your-authentication-token> [netmask=64] $0 your-name.dynv6.net [device]"
          exit 1
        fi

        if [ -z "$netmask" ]; then
          netmask=128
        fi

        if [ -n "$device" ]; then
          device="dev $device"
        fi

        address=$(${pkgs.iproute}/bin/ip -6 addr list scope global $device | ${pkgs.gnugrep}/bin/grep -v " fd" | ${pkgs.gnused}/bin/sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | ${pkgs.coreutils}/bin/head -n 1)

        if [ -z "$address" ]; then
          ${pkgs.coreutils}/bin/echo "no IPv6 address found"
          exit 1
        fi

        # address with netmask
        current=$address/$netmask

        if [ "$old" = "$current" ]; then
          ${pkgs.coreutils}/bin/echo "IPv6 address unchanged"
          exit
        fi

        # send addresses to dynv6
        ${pkgs.wget}/bin/wget -O- "http://dynv6.com/api/update?hostname=$hostname&ipv6=$current&token=$token"
        ${pkgs.wget}/bin/wget -O- "http://ipv4.dynv6.com/api/update?hostname=$hostname&ipv4=auto&token=$token"

        # save current address
        ${pkgs.coreutils}/bin/echo $current > $file
      '';
    };
  };
}
