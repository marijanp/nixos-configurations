final: prev: {
  firefox-addons = final.callPackages ./pkgs/firefox-addons {
    inherit (final.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
  };
}
