{ pkgs, ... }:
{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };
  # TODO: remove when https://nixpk.gs/pr-tracker.html?pr=187562 reaches nixpkgs-unstable
  programs.gnupg.package = pkgs.gnupg.overrideAttrs (old:
    if old.version == "2.3.7" then {
      patches = old.patches ++ [
        (pkgs.fetchpatch {
          name = "fix-yubikey.patch";
          url = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=patch;h=f34b9147eb3070bce80d53febaa564164cd6c977;hp=95651d1a4fec9bc5e36f623b2cdcc6a35e0c30bb";
          sha256 = "sha256-KD8H6N9oGx+85SetHx1OJku28J2dmsj/JkJudknCueU=";
        })
      ];
    } else { }
  );
}
