#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/packages.txt"

log() {
  printf '[apt] %s\n' "$*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing command: $1" >&2
    exit 1
  }
}

is_installed() {
  local pkg="$1"
  dpkg-query -W -f='${Status}\n' "$pkg" 2>/dev/null | grep -q '^install ok installed$'
}

read_packages() {
  [[ -f "$PACKAGES_FILE" ]] || return 0

  awk '
    {
      sub(/[[:space:]]*#.*/, "")   # 去掉行尾註釋
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)  # trim
      if ($0 != "") print $0
    }
  ' "$PACKAGES_FILE" | sort -u
}

main() {
  require_cmd sudo
  require_cmd apt
  require_cmd dpkg-query

  if [[ ! -f "$PACKAGES_FILE" ]]; then
    echo "packages.txt not found: $PACKAGES_FILE" >&2
    exit 1
  fi

  mapfile -t packages < <(read_packages)

  if [[ ${#packages[@]} -eq 0 ]]; then
    log "No packages declared in packages.txt"
    exit 0
  fi

  local missing=()
  local pkg
  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
      missing+=("$pkg")
    fi
  done

  if [[ ${#missing[@]} -eq 0 ]]; then
    log "All packages are already installed"
    exit 0
  fi

  log "Updating apt index"
  sudo apt update

  log "Installing missing packages:"
  printf '  %s\n' "${missing[@]}"

  sudo apt install -y "${missing[@]}"

  log "Done"
}

main "$@"
