{ pkgs, lib, ... }:
let 
  codium-settings-path = ".config/VSCodium/User/settings.json";
in
{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    cachix
    gopass
    gopass-jsonapi
    hledger
    niv
    qemu
    element-desktop
    firefox
    thunderbird
    solaar
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = (with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-vscode-remote.remote-ssh
      eamodio.gitlens
      zhuangtongfa.material-theme
      pkief.material-icon-theme
      jnoortheen.nix-ide
      haskell.haskell
      justusadam.language-haskell
      #llvm-vs-code-extensions.vscode-clangd
      #ms-python.python
      gruntfuggly.todo-tree
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "language-purescript";
        publisher = "nwolverson";
        version = "0.2.8";
        sha256 = "sha256-2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
      }
    ];
  };

  home.file.${codium-settings-path}.source = ./codium-settings.json;
}
