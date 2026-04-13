#!/usr/bin/env bash
# Package removal.
#
# Managed removal is record-driven:
# - files.txt: recorded file/symlink payload
# - created_dirs.txt: directories created during install
#
# Tracked removal is backend-driven:
# - track_remove_cmd if present
# - otherwise a backend-specific fallback based on recorded metadata

AIRLOCK_PROTECTED_DIRS_DEFAULT=(
  /
  /bin
  /boot
  /dev
  /etc
  /home
  /lib
  /lib64
  /media
  /mnt
  /opt
  /proc
  /root
  /run
  /sbin
  /srv
  /sys
  /tmp
  /usr
  /usr/local
  /var
)

al_print_protected_dirs() {
  local dir

  for dir in "${AIRLOCK_PROTECTED_DIRS_DEFAULT[@]}"; do
    printf '%s\n' "$dir"
  done

  if [ -n "${HOME:-}" ]; then
    printf '%s\n' "$HOME"
    printf '%s\n' "$HOME/.local"
    printf '%s\n' "$HOME/.config"
    printf '%s\n' "$HOME/.local/bin"
    printf '%s\n' "$HOME/.local/share"
    printf '%s\n' "$HOME/.local/state"
    printf '%s\n' "$HOME/.local/lib"
  fi

  if [ -n "${AIRLOCK_PROTECTED_DIRS_EXTRA:-}" ]; then
    printf '%s\n' "$AIRLOCK_PROTECTED_DIRS_EXTRA" | tr ':' '\n'
  fi
}

al_is_protected_dir() {
  local dir="$1"
  local protected

  while IFS= read -r protected; do
    [ -n "$protected" ] || continue
    [ "$dir" = "$protected" ] && return 0
  done < <(al_print_protected_dirs)

  return 1
}

al_created_dir_belongs_to_pkg() {
  local created_dirs_txt="$1"
  local dir="$2"

  [ -f "$created_dirs_txt" ] || return 1
  grep -Fx -- "$dir" "$created_dirs_txt" >/dev/null 2>&1
}

al_remove_file_auto() {
  local path="$1"

  if [ ! -e "$path" ] && [ ! -L "$path" ]; then
    return 0
  fi

  if al_can_delete_path_without_sudo "$path"; then
    rm -f -- "$path" || return 1
  else
    sudo rm -f -- "$path" || return 1
  fi

  al_log_debug "Removed file: $path"
}

al_rmdir_auto() {
  local dir="$1"

  if al_can_delete_path_without_sudo "$dir"; then
    rmdir -- "$dir" || return 1
  else
    sudo rmdir -- "$dir" || return 1
  fi

  al_log_debug "Removed empty directory: $dir"
}

al_collect_direct_parent_dirs() {
  local files_txt="$1"

  awk '
    function dirname(path,    n, parts, out, i) {
      n = split(path, parts, "/")
      if (n <= 1) return "/"
      out = ""
      for (i = 1; i < n; i++) {
        if (parts[i] != "") out = out "/" parts[i]
      }
      return (out == "" ? "/" : out)
    }

    {
      path = $0
      if (path == "") next
      print dirname(path)
    }
  ' "$files_txt" | awk '!seen[$0]++' | al_sort_paths_deepest_first
}

al_prune_dir_chain() {
  local start_dir="$1"
  local created_dirs_txt="$2"
  local dir="$start_dir"

  while [ -n "$dir" ] && [ "$dir" != "/" ]; do
    [ -d "$dir" ] || break
    al_dir_is_empty "$dir" || break
    al_is_protected_dir "$dir" && break
    al_created_dir_belongs_to_pkg "$created_dirs_txt" "$dir" || break

    al_rmdir_auto "$dir" || break
    dir="$(dirname "$dir")"
  done
}

al_load_pkg_meta() {
  local pkgdir="$1"
  local meta="$pkgdir/meta.env"

  [ -f "$meta" ] || al_die "Missing meta.env for package: $(basename "$pkgdir")"

  unset pkg_name pkg_version pkg_mode pkg_type prefix installed_at recipe_dir
  unset track_backend track_package_name track_package_version
  unset track_source_url track_source_file
  unset track_install_cmd track_remove_cmd track_query_cmd
  # shellcheck disable=SC1090
  . "$meta"
}

al_remove_pkg_record_dir() {
  local pkgdir="$1"

  if al_can_delete_path_without_sudo "$pkgdir"; then
    rm -rf -- "$pkgdir" || return 1
  else
    sudo rm -rf -- "$pkgdir" || return 1
  fi
}

al_run_recorded_track_remove() {
  if [ -n "${track_remove_cmd:-}" ]; then
    al_run_shell_with_optional_sudo "$track_remove_cmd"
    return $?
  fi

  case "${track_backend:-}" in
    dpkg|deb-dpkg|deb-apt)
      al_run_with_optional_sudo dpkg -r "${track_package_name:-$pkg_name}"
      ;;
    pacman)
      al_run_with_optional_sudo pacman -R --noconfirm "${track_package_name:-$pkg_name}"
      ;;
    *)
      al_die "Tracked package has no removable backend command recorded: ${track_backend:-unknown}"
      ;;
  esac
}

al_remove_managed_pkg() {
  local pkgdir="$1"
  local files="$pkgdir/files.txt"
  local created_dirs="$pkgdir/created_dirs.txt"
  local path
  local dir

  [ -f "$files" ] || al_die "Missing files.txt for package: $pkg_name"

  while IFS= read -r path; do
    [ -n "$path" ] || continue
    al_remove_file_auto "$path" || return 1
  done < "$files"

  if [ -f "$created_dirs" ]; then
    while IFS= read -r dir; do
      [ -n "$dir" ] || continue
      al_prune_dir_chain "$dir" "$created_dirs" || return 1
    done < <(al_collect_direct_parent_dirs "$files")
  else
    al_log_warn "created_dirs.txt not found; skipping directory prune"
  fi

  al_remove_pkg_record_dir "$pkgdir" || return 1
  al_log_info "Removed package record: $pkg_name"
}

al_remove_tracked_pkg() {
  local pkgdir="$1"

  if [ -n "${track_query_cmd:-}" ]; then
    if ! bash -lc "$track_query_cmd" >/dev/null 2>&1; then
      al_log_warn "Tracked backend no longer reports package as installed; removing record only"
      al_remove_pkg_record_dir "$pkgdir" || return 1
      al_log_info "Removed package record: $pkg_name"
      return 0
    fi
  fi

  al_run_recorded_track_remove || return 1
  al_remove_pkg_record_dir "$pkgdir" || return 1
  al_log_info "Removed tracked package record: $pkg_name"
}

al_remove_pkg() {
  local name="${1:-}"
  local pkgdir

  [ -n "$name" ] || al_die "Missing package name"

  pkgdir="$AIRLOCK_DB_ROOT/packages/$name"
  [ -d "$pkgdir" ] || al_die "Package not found in database: $name"

  al_load_pkg_meta "$pkgdir"

  al_log_info "Removing package: $name"
  al_log_info "Mode: ${pkg_mode:-managed}, Type: ${pkg_type:-unknown}"

  case "${pkg_mode:-managed}" in
    managed)
      al_remove_managed_pkg "$pkgdir"
      ;;
    tracked)
      al_remove_tracked_pkg "$pkgdir"
      ;;
    *)
      al_die "Unsupported recorded pkg_mode: ${pkg_mode:-unknown}"
      ;;
  esac
}
