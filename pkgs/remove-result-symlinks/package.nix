{
  writeShellApplication,
  coreutils,
  findutils,
}:

writeShellApplication {
  name = "remove-result-symlinks";

  runtimeInputs = [
    coreutils
    findutils
  ];

  text = ''
    set -euo pipefail

    if [ "$#" -ne 1 ]; then
      echo "Usage: remove-result-symlinks <directory>" >&2
      exit 1
    fi

    target_dir="$1"

    if [ ! -d "$target_dir" ]; then
      echo "Error: '$target_dir' is not a directory" >&2
      exit 1
    fi

    find "$target_dir" -type l -exec sh -c '
      for link do
        target="$(readlink -f -- "$link")" || continue

        case "$target" in
          /nix/store/*)
            printf "%s\n" "$link"
            rm -- "$link"
            ;;
        esac
      done
    ' sh {} +
  '';
}
