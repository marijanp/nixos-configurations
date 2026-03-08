{ ... }:
{
  sops.age = {
    sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    keyFile = "/var/lib/sops-nix/key.txt";
    # derives keyFile from the private SSH key if it doesn't exist
    generateKey = true;
  };
}
