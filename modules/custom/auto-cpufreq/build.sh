#!/usr/bin/env bash

REPO_URL="https://github.com/AdnanHodzic/auto-cpufreq.git"

if [ ! -e "$HOME/src/auto-cpufreq" ]; then
  git clone "$REPO_URL" "$HOME/src/auto-cpufreq"
fi

sudo apt install -y \
  python3 python3-pip python3-setuptools python3-build python3-installer python3-wheel \
  python3-psutil python3-click python3-distro python3-requests python3-gi \
  python3-pyinotify python3-urwid \
  dmidecode gir1.2-gtk-3.0 libgtk-3-0t64 python3-poetry-dynamic-versioning python3-poetry-core python3-poetry \
  python3-build

if [ -e "$HOME/src/auto-cpufreq" ]; then
  (
    cd "$HOME/src/auto-cpufreq"
    git checkout v3.0.0
    POETRY_DYNAMIC_VERSIONING_BYPASS=1 python3 -m build --wheel --no-isolation
  )
fi

