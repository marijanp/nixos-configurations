{
  config,
  lib,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };

  codexConfig = "${config.xdg.configHome}/codex/config.toml";

  transformedMcpServers =
    lib.optionalAttrs (config.programs.mcp.enable && config.programs.mcp.servers != { })
      (
        lib.mapAttrs (
          name: server:
          lib.hm.mcp.transformMcpServer {
            inherit server;
            exclude = [
              "headers"
              "type"
            ];
            extraTransforms = [
              (s: s // lib.optionalAttrs (s.headers or { } != { }) { http_headers = s.headers; })
              lib.hm.mcp.addType
              (lib.hm.mcp.wrapEnvFilesCommand { inherit pkgs name; })
            ];
          }
        ) config.programs.mcp.servers
      );

  mcpFragment = tomlFormat.generate "codex-mcp-servers.toml" {
    mcp_servers = transformedMcpServers;
  };
in
{
  programs.codex.enable = true;

  home.activation.updateCodexMcpServers = lib.mkIf (transformedMcpServers != { }) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      config_file=${lib.escapeShellArg codexConfig}
      fragment_file=${lib.escapeShellArg mcpFragment}
      begin_marker="# BEGIN home-manager managed MCP servers"
      end_marker="# END home-manager managed MCP servers"

      if [[ -v DRY_RUN ]]; then
        verboseEcho "Would update Codex MCP servers in $config_file"
      else
        mkdir -p "$(dirname "$config_file")"

        tmp_file="$(mktemp "''${config_file}.tmp.XXXXXX")"
        trap 'rm -f "$tmp_file"' EXIT

        if [ -f "$config_file" ]; then
          sed "/^$begin_marker$/,/^$end_marker$/d" "$config_file" > "$tmp_file"
        else
          : > "$tmp_file"
        fi

        {
          cat "$tmp_file"
          printf '\n\n%s\n' "$begin_marker"
          cat "$fragment_file"
          printf '%s\n' "$end_marker"
        } > "$config_file"
      fi
    ''
  );
}
