#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -e "$HOME/src/auto-cpufreq/dist/auto_cpufreq-1-py3-none-any.whl" ]; then
  sudo python3 -m installer "$HOME/src/auto-cpufreq/dist/auto_cpufreq-1-py3-none-any.whl"
  sudo cp --verbose "$SCRIPT_DIR/auto-cpufreq" "/etc/init.d/auto-cpufreq"
  sudo chmod +x /etc/init.d/auto-cpufreq
  sudo mkdir -p /usr/local/share/auto-cpufreq
  sudo cp -r --verbose "$HOME/src/auto-cpufreq/scripts" /usr/local/share/auto-cpufreq/
fi
