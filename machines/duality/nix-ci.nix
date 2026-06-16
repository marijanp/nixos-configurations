{ config, ... }:
{
  sops.secrets = {
    nix-ci-auth-token-id = { };
    nix-ci-auth-token-secret = { };
  };

  sops.templates."nix-ci-netrc" = {
    owner = config.users.users.marijan.name;
    group = config.users.users.marijan.group;
    mode = "0400";
    content = ''
      machine nix-ci.com
        login ${config.sops.placeholder.nix-ci-auth-token-id}
        password ${config.sops.placeholder.nix-ci-auth-token-secret}
      machine cache.nix-ci.com
        login ${config.sops.placeholder.nix-ci-auth-token-id}
        password ${config.sops.placeholder.nix-ci-auth-token-secret}
    '';
  };

  nix.settings = {
    builders-use-substitutes = true;
    netrc-file = config.sops.templates."nix-ci-netrc".path;
  };
}
