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
      version = "33.2.2";
      sha256 = "0a55ksf58d4fhk1vgafibxkg61rhyd6cl10wz9gwg22rykx6i8d9";
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
      version = "0.1.16";
      sha256 = "04ky1mzyjjr1mrwv3sxz4mgjcq5ylh6n01lvhb19h3fmwafkdxbp";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "1.0.7";
      sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
    }
    {
      name = "vscode-clangd";
      publisher = "llvm-vs-code-extensions";
      version = "0.1.13";
      sha256 = "0qjllvg2wwy3w8gg7q9dkbs0mccxxdq8cg59pbvw0vd8rxn71jpw";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2021.8.1159798656";
      sha256 = "030si91s53ii9mqwzf4djsdh7ranaky3x9m26s279n6g9i7vd3r7";
    }
    {
      name = "haskell";
      publisher = "haskell";
      version = "1.6.1";
      sha256 = "1l6nrbqkq1p62dkmzs4sy0rxbid3qa1104s3fd9fzkmc1sldzgsn";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.4.0";
      sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
    }
    {
      name = "todo-tree";
      publisher = "Gruntfuggly";
      version = "0.0.214";
      sha256 = "0rwxjnrl44rnhx3183037k6435xs4772p58a37azl5cahsyav1hk";
    }
  ];
in {
  vscodium-custom = pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = extensions;
    };
}
