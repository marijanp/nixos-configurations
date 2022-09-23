{ pkgs, lib, ... }:
let
  codium-settings-path =
    if pkgs.stdenv.isDarwin
    then "Library/Application\ Support/VSCodium/User/settings.json"
    else ".config/VSCodium/User/settings.json";
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = (with pkgs.vscode-extensions; [
      vscodevim.vim
      zhuangtongfa.material-theme
      pkief.material-icon-theme
      jnoortheen.nix-ide
      haskell.haskell
      justusadam.language-haskell
      gruntfuggly.todo-tree
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "language-purescript";
        publisher = "nwolverson";
        version = "0.2.8";
        sha256 = "sha256-2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
      }
      {
        name = "ide-purescript";
        publisher = "nwolverson";
        version = "0.25.12";
        sha256 = "sha256-tgZ0PnWrSDBNKBB5bKH/Fmq6UVNSRYZ8HJdzFDgxILk=";
      }
      {
        name = "vscode-bazel";
        publisher = "BazelBuild";
        version = "0.5.0";
        sha256 = "sha256-JJQSwU3B5C2exENdNsWEcxFSgWHnImYas4t/KLsgTj4=";
      }
    ];
  };

  home.file.${codium-settings-path}.source = ./codium-settings.json;
}
