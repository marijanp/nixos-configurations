{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.marijan.extraGroups = [ "libvirtd" ];
}
