{ pkgs, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
    
    ms-vscode-remote.remote-ssh
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "11.0.6";
      sha256 = "0qlaq7hn3m73rx9bmbzz3rc7khg0kw948z2j4rd8gdmmryy217yw";
    }
    {
      name = "vsc-material-theme";
      publisher = "Equinusocio";
      version = "33.0.0";
      sha256 = "1r8g9jm34xp7lld9mwv3sja1913aan0khxqrp7az89szwpnv73vg";
    }
    {
      name = "material-icon-theme";
      publisher = "PKief";
      version = "4.4.0";
      sha256 = "1m9mis59j9xnf1zvh67p5rhayaa9qxjiw9iw847nyl9vsy73w8ya";
    }
    {
      name = "nix-ide";
      publisher = "jnoortheen";
      version = "0.1.3";
      sha256 = "1c2yljzjka17hr213hiqad58spk93c6q6xcxvbnahhrdfvggy8al";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "0.1.2";
      sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
    }
    {
      name = "vscode-clangd";
      publisher = "llvm-vs-code-extensions";
      version = "0.1.8";
      sha256 = "0rhpgxwjkpl1iahjlaprdz0943lrngm56dicajd2rgcmgya6jxlq";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2020.11.371526539";
      sha256 = "0iavy4c209k53jkqsbhsvibzjj3fjxa500rv72fywgb2vxsi9fc3";
    }
  ];
in {
  custom-vscodium = pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = extensions;
    };
}
