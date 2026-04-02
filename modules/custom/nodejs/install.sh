#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/.nvm"

if [[ ! -d "$target_dir" ]]; then
  mkdir -p $target_dir
fi

if [[ ! -e "$target_dir/nvm.sh" ]]; then
  (
    export NVM_DIR="$target_dir"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install 25
  )
fi
