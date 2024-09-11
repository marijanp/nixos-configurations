let
  marijan.keys = [ "age1yubikey1q0tpa48d03dy59jcsjsx5a8zv0p8msr89ut7xgr64x5ujgkrn0ceulx4zwv" ];
  split.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMY3yyshqtmN2qO2RlifbxiuKfNg1jsn+RbA2+/bgwgc";
  splitpad.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHMJrYYVComJgquUVzDD91Z3roMKZQdYIGyZqbMjuOQfjKA";
  system.keys = [ splitpad.key split.key ];
in
{
  "rclone-drive-config.age".publicKeys = marijan.keys ++ system.keys;
  "smos-google-calendar-source.age".publicKeys = marijan.keys ++ system.keys;
  "smos-platonic-google-calendar-source.age".publicKeys = marijan.keys ++ system.keys;
  "smos-casper-google-calendar-source.age".publicKeys = marijan.keys ++ system.keys;
  "smos-sync-password.age".publicKeys = marijan.keys ++ system.keys;
  "gh-package-token.age".publicKeys = marijan.keys ++ system.keys;
}
