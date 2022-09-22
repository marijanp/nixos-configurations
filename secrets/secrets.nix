let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEm0jqNuG+NtkVVqa8s+kB+klSYCEctWbrskSiT440sW marijan@split"
  ];
in
{
  "helloworl.age".publicKeys = keys;
}
