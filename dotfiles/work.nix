{ ... }:
{
  imports = [
    ./desktop.nix
  ];

  programs.chromium = {
    enable = true;
    extensions = [
    ];
  };
}
