{ pkgs, lib, ... }:
{
  home.username = "marijan";
  home.homeDirectory = if builtins.currentSystem == "x86_64-darwin" then "/Users/marijan" else "/home/marijan";
}
