{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  programs.mcp = {
    enable = true;
    servers = {
      nixos = {
        enabled = true;
        command = lib.getExe pkgs.mcp-nixos;
      };
      github = {
        enabled = true;
        command = lib.getExe pkgs.github-mcp-server;
        args = [ "stdio" ];
        env.GITHUB_PERSONAL_ACCESS_TOKEN.file = osConfig.sops.secrets.gh-mcp-token.path;
      };
    };
  };
}
