{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./options/networking.nix
    ./options/localization.nix
    ./options/nix.nix
    ./options/nixpkgs.nix
    ./services/ssh.nix
    ./services/avahi.nix
    ./services/wireguard
    ./services/ntfy-nixos-switch.nix
    ./services/ntfy-host-status.nix
  ];

  environment.systemPackages = [ pkgs.kitty.terminfo ];

  sops.secrets.ntfy-publisher-password = {
    sopsFile = ../secrets/ntfy.yaml;
  };
  programs.bash.promptInit = ''
    PS1="\[\e[36m\]\u@\H\[\e[m\] | 📅 \d ⌚️ \A\n[\w]\$ "
  '';

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
