{ config, ... }:
{
  nix.settings.trusted-users = [ "deploy" ];

  security.sudo.extraRules = [
    {
      users = [ "deploy" ];
      commands = [
        {
          command = "/bin/sh -c * sh nix-env *";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/bin/sh -c * sh systemd-run *";
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
