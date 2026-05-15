#!/usr/bin/env bash
# tsl-to-nss.sh — Import TSL certificates into an NSS database.
#
# Dependencies: curl (for URLs), tsl-extract, certutil (from the nss package)

set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") [-h] <tsl-source> <nss-db-dir>

  tsl-source  URL (http:// or https://) or local file path of a TSL XML file
  nss-db-dir  Path to an NSS database directory (created if missing,
              no password protection)

Root (self-signed) certificates are imported with trust CT,CT,CT so they
are treated as trusted CAs for TLS, S/MIME, and object signing.
Non-root certificates are imported without trust flags (available for
chain building but not explicitly trusted).
EOF
    exit "${1:-1}"
}

die() { echo "Error: $*" >&2; exit 1; }

[[ $# -ge 1 && ( "$1" == "-h" || "$1" == "--help" ) ]] && usage 0
[[ $# -eq 2 ]] || usage

TSL_SOURCE="$1"
DB_DIR="$2"

if [[ "$TSL_SOURCE" == http://* || "$TSL_SOURCE" == https://* ]]; then
    command -v curl &>/dev/null || die "'curl' is not installed or not in PATH"
fi
for cmd in tsl-extract certutil; do
    command -v "$cmd" &>/dev/null || die "'$cmd' is not installed or not in PATH"
done

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

root_dir="$work_dir/roots"
non_root_dir="$work_dir/non_roots"

if [[ "$TSL_SOURCE" == http://* || "$TSL_SOURCE" == https://* ]]; then
    tsl_file="$work_dir/tsl.xml"
    echo "Downloading TSL from $TSL_SOURCE ..."
    curl -fsSL "$TSL_SOURCE" -o "$tsl_file"
else
    [[ -f "$TSL_SOURCE" ]] || die "file not found: $TSL_SOURCE"
    tsl_file="$TSL_SOURCE"
    echo "Reading TSL from $TSL_SOURCE ..."
fi

if [[ ! -f "$DB_DIR/cert9.db" && ! -f "$DB_DIR/cert8.db" ]]; then
    echo "Creating NSS database at $DB_DIR ..."
    mkdir -p "$DB_DIR"
    certutil -N -d "$DB_DIR" --empty-password
else
    echo "Using existing NSS database at $DB_DIR."
fi

cert_index=1

echo "Extracting root certificates ..."
tsl-extract "$tsl_file" --root -f der -o "$root_dir" 2>&1 || true

if [[ -d "$root_dir" ]]; then
    for der_file in "$root_dir"/*.der; do
        [[ -e "$der_file" ]] || break
        base=$(basename "${der_file%.der}"); name_part="${base#????_}"
        nickname=$(printf "%04d_%s" "$cert_index" "$name_part")
        cert_index=$((cert_index + 1))
        echo "  [root] $nickname"
        certutil -A -d "$DB_DIR" -n "$nickname" -t "CT,CT,CT" -i "$der_file" \
            || echo "  Warning: could not add '$nickname' (skipping)" >&2
    done
fi

echo "Extracting non-root certificates ..."
tsl-extract "$tsl_file" --not-root -f der -o "$non_root_dir" 2>&1 || true

if [[ -d "$non_root_dir" ]]; then
    for der_file in "$non_root_dir"/*.der; do
        [[ -e "$der_file" ]] || break
        base=$(basename "${der_file%.der}"); name_part="${base#????_}"
        nickname=$(printf "%04d_%s" "$cert_index" "$name_part")
        cert_index=$((cert_index + 1))
        echo "  [non-root] $nickname"
        certutil -A -d "$DB_DIR" -n "$nickname" -t ",," -i "$der_file" \
            || echo "  Warning: could not add '$nickname' (skipping)" >&2
    done
fi

echo "Done."
