#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
AIRLOCK_BIN="$REPO_ROOT/bin/airlock"

TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/airlock-smoke.XXXXXX")"
trap 'rm -rf "$TMP_ROOT"' EXIT

mkdir -p "$TMP_ROOT/fakebin"
cat > "$TMP_ROOT/fakebin/sudo" <<'SUDO'
#!/usr/bin/env bash
printf 'unexpected sudo invocation: %s\n' "$*" >&2
exit 99
SUDO
chmod 755 "$TMP_ROOT/fakebin/sudo"

export PATH="$TMP_ROOT/fakebin:$PATH"
export AIRLOCK_PREFIX="$TMP_ROOT/prefix"
export AIRLOCK_DB_ROOT="$TMP_ROOT/db"
export AIRLOCK_TMPDIR="$TMP_ROOT/tmp"
export AIRLOCK_RECIPES_DIR="$REPO_ROOT/tests/recipes"
export AIRLOCK_UI_COLOR=0
export AIRLOCK_LOG_LEVEL=error

bash "$AIRLOCK_BIN" install smoke-managed

[ -x "$AIRLOCK_PREFIX/bin/smoke-managed" ]
[ -f "$AIRLOCK_PREFIX/libexec/smoke-managed/smoke-bin" ]
[ -f "$AIRLOCK_PREFIX/share/smoke-managed/docs/readme.txt" ]
[ -f "$AIRLOCK_PREFIX/share/applications/smoke-managed.desktop" ]

smoke_output="$($AIRLOCK_PREFIX/bin/smoke-managed)"
[ "$smoke_output" = "smoke-managed-ok" ]

files_output="$(bash "$AIRLOCK_BIN" files smoke-managed)"
printf '%s\n' "$files_output" | grep -F "$AIRLOCK_PREFIX/bin/smoke-managed" >/dev/null
printf '%s\n' "$files_output" | grep -F "$AIRLOCK_PREFIX/share/applications/smoke-managed.desktop" >/dev/null

info_output="$(bash "$AIRLOCK_BIN" info smoke-managed)"
printf '%s\n' "$info_output" | grep -F "smoke-managed 1.0.0" >/dev/null
printf '%s\n' "$info_output" | grep -F "mode" | grep -F "managed" >/dev/null

bash "$AIRLOCK_BIN" remove smoke-managed

[ ! -e "$AIRLOCK_PREFIX/bin/smoke-managed" ]
[ ! -d "$AIRLOCK_DB_ROOT/packages/smoke-managed" ]

printf 'smoke test passed: managed lifecycle\n'
