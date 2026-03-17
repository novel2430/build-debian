#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REMOTES_FILE="$SCRIPT_DIR/remotes.txt"
APPS_FILE="$SCRIPT_DIR/apps.txt"

log() {
  printf '[flatpak] %s\n' "$*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing command: $1" >&2
    exit 1
  }
}

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

strip_comment() {
  local s="$1"
  s="${s%%#*}"
  trim "$s"
}

remote_exists() {
  local name="$1"
  flatpak remotes --user --columns=name 2>/dev/null | grep -Fxq "$name"
}

app_installed() {
  local app_id="$1"
  flatpak list --user --app --columns=application 2>/dev/null | grep -Fxq "$app_id"
}

apply_remotes() {
  [[ -f "$REMOTES_FILE" ]] || {
    log "No remotes.txt found, skipping remotes"
    return 0
  }

  log "Applying remotes from $REMOTES_FILE"

  while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
    line="$(strip_comment "$raw_line")"
    [[ -n "$line" ]] || continue

    # shellcheck disable=SC2206
    parts=($line)
    if [[ ${#parts[@]} -lt 2 ]]; then
      echo "Invalid remote line: $raw_line" >&2
      exit 1
    fi

    name="${parts[0]}"
    url="${parts[1]}"

    if remote_exists "$name"; then
      log "Remote already exists: $name"
    else
      log "Adding remote: $name -> $url"
      flatpak remote-add --user --if-not-exists "$name" "$url"
    fi
  done < "$REMOTES_FILE"
}

apply_apps() {
  [[ -f "$APPS_FILE" ]] || {
    log "No apps.txt found, skipping apps"
    return 0
  }

  log "Applying apps from $APPS_FILE"

  while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
    line="$(strip_comment "$raw_line")"
    [[ -n "$line" ]] || continue

    # shellcheck disable=SC2206
    parts=($line)
    if [[ ${#parts[@]} -lt 2 ]]; then
      echo "Invalid app line: $raw_line" >&2
      exit 1
    fi

    remote="${parts[0]}"
    app_id="${parts[1]}"

    if ! remote_exists "$remote"; then
      echo "Remote '$remote' is not configured for app '$app_id'" >&2
      exit 1
    fi

    if app_installed "$app_id"; then
      log "App already installed: $app_id"
    else
      log "Installing app: $app_id from $remote"
      flatpak install --user -y "$remote" "$app_id"
    fi
  done < "$APPS_FILE"
}

main() {
  require_cmd flatpak

  apply_remotes
  apply_apps

  log "Done"
}

main "$@"
