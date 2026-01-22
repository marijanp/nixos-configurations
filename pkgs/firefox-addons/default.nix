{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}:
{
  "croatian-dictionary" = buildFirefoxXpiAddon {
    pname = "croatian-dictionary";
    version = "1.6resigned1";
    addonId = "hr-HR-2@dictionaries.addons.mozilla.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4287958/croatian_dictionary-1.6resigned1.xpi";
    sha256 = "09a93269380d686a71ca5b873a2d7b683ef5a5325980342bc2cd16df8044afe7";
    meta = with lib; {
      homepage = "https://github.com/akoncic/mozillacroatiandictionary";
      description = "Croatian Dictionary (Hrvatski Rječnik) for Mozilla";
      license = licenses.gpl3;
      mozPermissions = [ ];
      platforms = platforms.all;
    };
  };
}
