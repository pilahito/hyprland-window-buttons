#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
buttons_dir="${HYPR_BUTTONS_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/hypr/winbuttons}"
[[ -d "$buttons_dir" ]] || { echo 'Configura primero los botones de hyprbars.' >&2; exit 1; }
backup_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr-winbuttons/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
for name in _ventana-cursor.sh maximizar.sh; do
    [[ ! -e "$buttons_dir/$name" ]] || cp -p "$buttons_dir/$name" "$backup_dir/"
    install -m 755 "$project_dir/scripts/$name" "$buttons_dir/$name"
done
printf 'Scripts instalados. Copia de seguridad: %s\n' "$backup_dir"
