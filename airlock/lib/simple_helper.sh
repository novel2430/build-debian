#!/usr/bin/env bash
# simple_helper.sh
#
# Optional helper functions for recipe authors.
#
# Design goals:
# - Keep helpers small and explicit
# - Avoid hiding too much policy inside helpers
# - Reuse WORKDIR/STAGE_DIR/PREFIX managed by the framework
# - Make common recipe patterns easier to write and reuse
#
# Notes:
# - These helpers are intentionally opt-in.
# - Recipes may still implement their own logic directly.
# - Helpers assume that core framework variables/functions are already available:
#     WORKDIR
#     STAGE_DIR
#     PREFIX
#     al_die
#     al_require_cmd
#     al_fetch_url
#     al_mkdir


# -----------------------------------------------------------------------------
# al_fetch_cached_url
#
# Download a file only if the target file does not already exist.
#
# Parameters:
#   $1 - Source URL
#   $2 - Output file path
#
# Behavior:
# - If the output file already exists, the function does nothing and returns 0.
# - If the output file does not exist, the function downloads it using al_fetch_url.
# - The parent directory of the output path is created automatically.
#
# Notes:
# - This helper is intentionally simple:
#   it only checks for file existence, not checksums or freshness.
# - This is suitable for WORKDIR-backed cache usage.
# -----------------------------------------------------------------------------
al_fetch_cached_url() {
  local url="$1"
  local output="$2"

  [ -n "$url" ] || al_die "al_fetch_cached_url: missing url"
  [ -n "$output" ] || al_die "al_fetch_cached_url: missing output path"

  if [ -e "$output" ]; then
    al_log_info "Using cached download: $output"
    return 0
  fi

  al_mkdir "$(dirname "$output")" || return 1

  al_log_info "Downloading: $url"
  al_fetch_url "$url" "$output"
}


# -----------------------------------------------------------------------------
# al_git_checkout_repo
#
# Ensure that a Git repository exists locally and is checked out to a target ref.
#
# Parameters:
#   $1 - Repository URL
#   $2 - Local repository directory
#   $3 - Target ref (tag, branch, or commit)
#
# Behavior:
# - If the local repository directory does not contain .git, clone the repo.
# - If the repository already exists, reuse it.
# - Fetch updates from origin.
# - Checkout the requested ref.
#
# Notes:
# - This helper is intended for WORKDIR cache reuse.
# - The helper does not clean local changes automatically.
# - The helper assumes the repo directory is dedicated to this recipe's use.
# -----------------------------------------------------------------------------
al_git_checkout_repo() {
  local repo_url="$1"
  local repo_dir="$2"
  local ref="$3"

  [ -n "$repo_url" ] || al_die "al_git_checkout_repo: missing repo_url"
  [ -n "$repo_dir" ] || al_die "al_git_checkout_repo: missing repo_dir"
  [ -n "$ref" ] || al_die "al_git_checkout_repo: missing ref"

  al_require_cmd git
  al_mkdir "$(dirname "$repo_dir")" || return 1

  if [ ! -d "$repo_dir/.git" ]; then
    al_log_info "Cloning repository: $repo_url -> $repo_dir"
    git clone "$repo_url" "$repo_dir" || return 1
  else
    al_log_info "Using cached repository: $repo_dir"
  fi

  (
    cd "$repo_dir" || exit 1

    # Fetch remote refs/tags so repeated installs can reuse the same clone
    # while still being able to move to the requested target ref.
    git fetch --tags origin || exit 1

    # Checkout the requested ref directly.
    git checkout "$ref" || exit 1
  ) || return 1
}


# -----------------------------------------------------------------------------
# al_git_checkout_repo_with_submodules
#
# Same as al_git_checkout_repo, but also initializes and updates submodules.
#
# Parameters:
#   $1 - Repository URL
#   $2 - Local repository directory
#   $3 - Target ref (tag, branch, or commit)
#
# Behavior:
# - Reuses or clones the repository
# - Fetches refs/tags
# - Checks out the requested ref
# - Updates submodules recursively
#
# Notes:
# - Use this helper for projects such as wezterm that require submodules.
# -----------------------------------------------------------------------------
al_git_checkout_repo_with_submodules() {
  local repo_url="$1"
  local repo_dir="$2"
  local ref="$3"

  al_git_checkout_repo "$repo_url" "$repo_dir" "$ref" || return 1

  (
    cd "$repo_dir" || exit 1
    git submodule update --init --recursive || exit 1
  ) || return 1
}

# -----------------------------------------------------------------------------
# al_stage_install_dir
#
# Install a directory into the framework-controlled stage tree under PREFIX.
#
# Parameters:
#   $1 - Source directory path
#   $2 - Destination path relative to PREFIX
#   $3 - Optional file mode to apply to all files (default: preserve)
#
# Behavior:
# - Resolves final path as $STAGE_DIR$PREFIX/<dest_relpath>
# - Creates parent directories automatically
# - Copies all files and subdirectories
# - Optionally sets all files to the specified mode
#
# Examples:
#   al_stage_install_dir "$SRCDIR/share/icons" "share/icons"
#   al_stage_install_dir "$SRCDIR/config" "etc/annotator" 644
#
# Notes:
# - dest_relpath must be relative to PREFIX, not absolute
# - Preserves symlinks, timestamps, and permissions unless mode is specified
# -----------------------------------------------------------------------------
al_stage_install_dir() {
  local src="$1"
  local dest_relpath="$2"
  local mode="${3:-}"
  local dest

  [ -n "$src" ] || al_die "al_stage_install_dir: missing source directory"
  [ -n "$dest_relpath" ] || al_die "al_stage_install_dir: missing destination path"
  [ -d "$src" ] || al_die "al_stage_install_dir: source is not a directory: $src"

  case "$dest_relpath" in
    /*)
      al_die "al_stage_install_dir: destination must be relative to PREFIX: $dest_relpath"
      ;;
  esac

  dest="$STAGE_DIR$PREFIX/$dest_relpath"
  al_mkdir "$dest" || return 1

  # Copy directory recursively, preserve attributes
  cp -a "$src/." "$dest/" || return 1

  # If a mode is specified, apply to all files
  if [ -n "$mode" ]; then
    find "$dest" -type f -exec chmod "$mode" {} \;
  fi

  al_log_info "Installed directory: $src -> $dest"
}

# -----------------------------------------------------------------------------
# al_stage_install_file
#
# Install one file into the framework-controlled stage tree under PREFIX.
#
# Parameters:
#   $1 - Source file path
#   $2 - Destination path relative to PREFIX
#   $3 - File mode (optional, default: 755)
#
# Behavior:
# - Resolves the final path as:
#     $STAGE_DIR$PREFIX/$dest_relpath
# - Creates parent directories automatically
# - Installs the file with install -Dm<mode>
#
# Examples:
#   al_stage_install_file "$SRCDIR/target/release/yazi" "bin/yazi" 755
#   al_stage_install_file "$SRCDIR/icon.svg" "share/icons/hicolor/scalable/apps/foo.svg" 644
#
# Notes:
# - dest_relpath must be relative to PREFIX, not an absolute path.
# - The function rejects absolute destination paths to avoid ambiguity.
# -----------------------------------------------------------------------------
al_stage_install_file() {
  local src="$1"
  local dest_relpath="$2"
  local mode="${3:-755}"
  local dest

  [ -n "$src" ] || al_die "al_stage_install_file: missing source path"
  [ -n "$dest_relpath" ] || al_die "al_stage_install_file: missing destination path"

  [ -e "$src" ] || al_die "al_stage_install_file: source does not exist: $src"

  case "$dest_relpath" in
    /*)
      al_die "al_stage_install_file: destination must be relative to PREFIX: $dest_relpath"
      ;;
  esac

  dest="$STAGE_DIR$PREFIX/$dest_relpath"
  al_mkdir "$(dirname "$dest")" || return 1

  install -Dm"$mode" "$src" "$dest" || return 1
}

# -----------------------------------------------------------------------------
# al_stage_install_icon
#
# Install an application icon into the staged hicolor icon theme tree.
#
# Parameters:
#   $1 - Source icon file path
#   $2 - Icon size directory, for example:
#          128x128
#          scalable
#   $3 - Icon name without extension, for example:
#          wezterm
#   $4 - File extension (optional)
#
# Behavior:
# - Resolves the destination as:
#     $STAGE_DIR$PREFIX/share/icons/hicolor/<size>/apps/<name>.<ext>
# - If extension is omitted, it is inferred from the source filename.
# - Parent directories are created automatically.
#
# Examples:
#   al_stage_install_icon "$SRCDIR/icon.svg" "scalable" "wezterm"
#   al_stage_install_icon "$SRCDIR/icon.png" "128x128" "wezterm" "png"
#
# Notes:
# - This helper is intentionally limited to the hicolor theme layout.
# - It is suitable for common desktop application recipes.
# -----------------------------------------------------------------------------
al_stage_install_icon() {
  local src="$1"
  local size_dir="$2"
  local icon_name="$3"
  local ext="${4:-}"
  local dest

  [ -n "$src" ] || al_die "al_stage_install_icon: missing source path"
  [ -n "$size_dir" ] || al_die "al_stage_install_icon: missing size directory"
  [ -n "$icon_name" ] || al_die "al_stage_install_icon: missing icon name"
  [ -e "$src" ] || al_die "al_stage_install_icon: source does not exist: $src"

  if [ -z "$ext" ]; then
    ext="${src##*.}"
    [ -n "$ext" ] || al_die "al_stage_install_icon: failed to infer extension from: $src"
  fi

  dest="$STAGE_DIR$PREFIX/share/icons/hicolor/$size_dir/apps/$icon_name.$ext"
  al_mkdir "$(dirname "$dest")" || return 1

  install -Dm644 "$src" "$dest" || return 1
}


# -----------------------------------------------------------------------------
# al_stage_write_desktop_entry
#
# Write a .desktop file into the staged applications directory.
#
# Parameters:
#   $1 - Desktop file name without extension
#   stdin - Desktop entry content
#
# Behavior:
# - Writes the desktop file to:
#     $STAGE_DIR$PREFIX/share/applications/<name>.desktop
# - Creates parent directories automatically.
#
# Example:
#   al_stage_write_desktop_entry "wezterm" <<'EOF'
#   [Desktop Entry]
#   Name=WezTerm
#   Exec=wezterm
#   Icon=wezterm
#   Type=Application
#   Categories=System;TerminalEmulator;
#   EOF
#
# Notes:
# - The helper only manages the destination path.
# - The recipe still owns the actual desktop entry content.
# -----------------------------------------------------------------------------
al_stage_write_desktop_entry() {
  local name="$1"
  local dest

  [ -n "$name" ] || al_die "al_stage_write_desktop_entry: missing desktop entry name"

  dest="$STAGE_DIR$PREFIX/share/applications/$name.desktop"
  al_mkdir "$(dirname "$dest")" || return 1

  cat > "$dest" || return 1
}

# -----------------------------------------------------------------------------
# al_stage_install_wrapper
#
# Install a shell wrapper script into the stage tree under PREFIX.
#
# Parameters:
#   $1 - Destination path relative to PREFIX (e.g., "bin/emacs")
#   stdin / heredoc - Wrapper script content
#   optional: mode (default 755)
#
# Behavior:
# - Writes content to $STAGE_DIR$PREFIX/<dest>
# - Creates parent directories automatically
# - Sets executable permission
#
# Example usage:
#   al_stage_install_wrapper "bin/emacs" <<'EOF'
#   #!/usr/bin/env bash
#   export WEBKIT_DISABLE_COMPOSITING_MODE=1
#   exec "$PREFIX/bin/emacs-29.4" "$@"
#   EOF
# -----------------------------------------------------------------------------
al_stage_install_wrapper() {
  local dest="$1"
  local mode="${2:-755}"
  local full="$STAGE_DIR$PREFIX/$dest"

  [ -n "$dest" ] || al_die "al_stage_install_wrapper: missing destination path"

  al_mkdir "$(dirname "$full")" || return 1

  # Write wrapper script content from stdin
  cat > "$full" || return 1

  # Set executable permissions
  chmod +x "$full" || return 1

  al_log_info "Installed wrapper: $full"
}
