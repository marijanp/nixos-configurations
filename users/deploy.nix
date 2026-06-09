{ config, ... }:
{
  nix.settings.trusted-users = [ "deploy" ];

  security.sudo.extraRules = [
    {
      users = [ "deploy" ];
      commands = [
        {
          command = "/bin/sh -c exec env -i PATH=\"\${PATH-}\" \"$@\" sh nix-env -p /nix/var/nix/profiles/system --set /nix/store/*-nixos-system-${config.networking.hostName}-*";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/bin/sh -c * sh systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER -E NIXOS_NO_CHECK --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration /nix/store/*-nixos-system-${config.networking.hostName}-*/bin/switch-to-configuration *";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  users.users.deploy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKJMTVrY0qbJfu2g1TocLxRrYc/AjlnUuR35Y4biaLThAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINqRF/kf3iqIZsL8mdWv7qbJrYEc0peWqByjPjFQoBt8AAAABHNzaDo="
    ];
    hashedPassword = "!";
  };
}
