{ pkgs, ... }:
{
  systemd.services.pwm-fan = {
    description = "Temperature-based PWM fan control";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = pkgs.writeShellScript "pwm-fan" ''
        hwmon=$(grep -rl "pwmfan" /sys/class/hwmon/*/name | head -1 | xargs dirname)
        echo 1 > "$hwmon/pwm1_enable"

        while true; do
          max_temp=0
          for zone in /sys/class/thermal/thermal_zone*/; do
            type=$(cat "$zone/type")
            case "$type" in
              *core*|*center*|*package*)
                temp=$(( $(cat "$zone/temp") / 1000 ))
                [ "$temp" -gt "$max_temp" ] && max_temp=$temp
                ;;
            esac
          done

          if [ "$max_temp" -lt 40 ]; then
            pwm=51
          elif [ "$max_temp" -lt 50 ]; then
            pwm=120
          elif [ "$max_temp" -lt 60 ]; then
            pwm=180
          elif [ "$max_temp" -lt 70 ]; then
            pwm=220
          else
            pwm=255
          fi

          echo "$pwm" > "$hwmon/pwm1"
          sleep 5
        done
      '';
    };
  };
}
