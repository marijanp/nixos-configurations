{ pkgs, ... }:
{
  imports = [
    ./desktop.nix
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "lpfcbjknijpeeillifnkikgncikgfhdo"; } # nami wallet
      { id = "abkahkcbhngaebpcgfmhkoioedceoigp"; } # casper wallet
    ];
  };
}
