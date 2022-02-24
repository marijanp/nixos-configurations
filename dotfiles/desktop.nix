{ pkgs, lib, ... }:
let 
  codium-settings-path = if builtins.currentSystem != "x86_64-darwin"
                         then ".config/VSCodium/User/settings.json"
                         else "Library/Application Support/VSCodium/User/settings.json";
in
{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    cachix
    gopass
    gopass-jsonapi
    haskell-language-server
    hledger
    niv
    qemu
  ] ++ lib.optionals (builtins.currentSystem != "x86_64-darwin") [
    element-desktop
    firefox
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
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
    ];
  };

  home.file.${codium-settings-path}.source = ./codium-settings.json;
}
