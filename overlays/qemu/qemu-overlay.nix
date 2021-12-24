self: super:
let
 nixpkgs-mroi = import (builtins.fetchTarball {
  name = "nixpkgs-mroi";
  url = "https://github.com/mroi/nixpkgs/archive/416488360b334083743b08d94f7f76c526db0042.tar.gz";
  sha256 = "1r6imvl8mw8ygfzp3wv4ckskas30635facag2j5m7n14cwab3ml0";
}) {};
in
{
   qemu = nixpkgs-mroi.qemu.overrideAttrs (attrs: { preConfigure = attrs.preConfigure + "substituteInPlace meson.build --replace \'if exe_sign\' \'if false\'";});
}
