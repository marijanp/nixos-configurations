{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.firefox.policies.SecurityDevices = lib.mkIf config.programs.firefox.enable {
    "CertiliaMiddleware" = "${pkgs.certilia}/lib/pkcs11/libCertiliaPkcs11.so";
  };
  home.packages = [ pkgs.certilia ];
}
