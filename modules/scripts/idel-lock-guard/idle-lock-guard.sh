#!/usr/bin/env bash

set -u

USERNAME="novel2430"
INTERVAL=10
WM_STATE_FILE="/home/$USERNAME/.wm_state"

ID_BIN="id"
XSET_BIN="xset"
PGREP_BIN="pgrep"
AWK_BIN="awk"
MY_SWAYIDLE_BIN="/home/$USERNAME/.local/bin/my-swayidle"
NIRI_SWAYIDLE_BIN="niri-swayidle"
XSET_DPMS_TIME="300"

log() {
  echo "[idle_guard] $*"
}

get_userid() {
  "$ID_BIN" -u "$USERNAME"
}

read_wm_state() {
  if [[ ! -f "$WM_STATE_FILE" ]]; then
    log "wm_state file not found: $WM_STATE_FILE, exiting"
    exit 0
  fi

  local state
  state="$(cat "$WM_STATE_FILE" 2>/dev/null || true)"

  if [[ -z "$state" ]]; then
    log "wm_state file is empty: $WM_STATE_FILE, exiting"
    exit 0
  fi

  printf '%s\n' "$state"
}

get_session_type() {
  local wm_state="$1"

  if [[ "$wm_state" == "X11" ]]; then
    echo "x11"
  else
    echo "wayland"
  fi
}

get_swayidle_pids() {
  "$PGREP_BIN" -x swayidle || true
}

is_niri_running() {
  "$PGREP_BIN" -x niri >/dev/null 2>&1
}

is_locked() {
  "$PGREP_BIN" -f i3lock >/dev/null 2>&1 && return 0
  "$PGREP_BIN" -f swaylock >/dev/null 2>&1 && return 0
  return 1
}

enable_idle_lock() {
  local session_type="$1"
  local swayidle_pids="$2"

  case "$session_type" in
    x11)
      log "Enabling X11 idle lock / DPMS"
      xset dpms $XSET_DPMS_TIME $XSET_DPMS_TIME $XSET_DPMS_TIME
      ;;
    wayland)
      if [[ -z "$swayidle_pids" ]]; then
        log "Enabling Wayland swayidle"
        if is_niri_running; then
          log "Niri detected, starting niri-swayidle"
          "$NIRI_SWAYIDLE_BIN" >/dev/null 2>&1 &
        else
          "$MY_SWAYIDLE_BIN" >/dev/null 2>&1 &
        fi
      fi
      ;;
  esac
}

disable_idle_lock() {
  local session_type="$1"
  local swayidle_pids="$2"

  case "$session_type" in
    x11)
      log "Disabling X11 DPMS"
      "$XSET_BIN" -dpms
      ;;
    wayland)
      if [[ -n "$swayidle_pids" ]]; then
        log "Stopping swayidle"
        kill -TERM $swayidle_pids 2>/dev/null || true
      fi
      ;;
  esac
}

main() {
  local userid
  userid="$(get_userid)"

  export XAUTHORITY="/home/$USERNAME/.Xauthority"
  export XDG_RUNTIME_DIR="/run/user/$userid"

  local last_locked_state=""
  local current_locked_state=""
  local wm_state=""
  local session_type=""
  local swayidle_pids=""

  wm_state="$(read_wm_state)"
  session_type="$(get_session_type "$wm_state")"

  if [[ "$session_type" == "wayland" ]]; then
    export WAYLAND_DISPLAY="$wm_state"
  else
    unset WAYLAND_DISPLAY || true
  fi

  log "Started with session_type=$session_type wm_state=$wm_state"

  while true; do
    wm_state="$(read_wm_state)"
    session_type="$(get_session_type "$wm_state")"

    if [[ "$session_type" == "wayland" ]]; then
      export WAYLAND_DISPLAY="$wm_state"
    else
      unset WAYLAND_DISPLAY || true
    fi

    swayidle_pids="$(get_swayidle_pids)"

    if is_locked; then
      current_locked_state="locked"
    else
      current_locked_state="unlocked"
    fi

    if [[ "$current_locked_state" != "$last_locked_state" ]]; then
      log "Screen state changed: ${last_locked_state:-unknown} -> $current_locked_state (session=$session_type)"

      if [[ "$current_locked_state" == "locked" ]]; then
        enable_idle_lock "$session_type" "$swayidle_pids"
      else
        disable_idle_lock "$session_type" "$swayidle_pids"
      fi

      last_locked_state="$current_locked_state"
    fi

    sleep "$INTERVAL"
  done
}

main "$@"
