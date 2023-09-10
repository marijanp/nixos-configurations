let
  marijan.keys = [ "age1yubikey1q0tpa48d03dy59jcsjsx5a8zv0p8msr89ut7xgr64x5ujgkrn0ceulx4zwv" ];
  localhost.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHMJrYYVComJgquUVzDD91Z3roMKZQdYIGyZqbMjuOQfjKA" ];
in
{
  "rclone-drive-config.age".publicKeys = marijan.keys ++ localhost.keys;
}
