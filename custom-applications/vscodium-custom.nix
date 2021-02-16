{ pkgs, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
    vscodevim.vim 
    ms-vscode-remote.remote-ssh
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "11.2.1";
      sha256 = "1ba72sr7mv9c0xzlqlxbv1x8p6jjvdjkkf7dn174v8b8345164v6";
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
      version = "0.1.7";
      sha256 = "1bw4wyq9abimxbhl7q9g8grvj2ax9qqq6mmqbiqlbsi2arvk0wrm";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "1.0.1";
      sha256 = "0kvfp2hlrda91n3digbpdhqr84gdcshxqnybfqbkq2yzjbidmyjg";
    }
    {
      name = "vscode-clangd";
      publisher = "llvm-vs-code-extensions";
      version = "0.1.9";
      sha256 = "0kfxpcgxaswq2d1ybf9c5wzlqarcvy0fd0dg06fi4gfmnfrd6zga";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2021.1.502429796";
      sha256 = "0drvpr98gryldbfmwjnyig8pmalrd22biqmhkhvih3sxzcwsyqjk";
    }
  ];
in {
  custom-vscodium = pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = extensions;
    };
}
