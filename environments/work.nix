{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["marijan"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}

