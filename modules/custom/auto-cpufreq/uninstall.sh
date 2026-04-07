#!/usr/bin/env bash

sudo rc-update del auto-cpufreq
sudo rc-service auto-cpufreq stop
sudo rm -vf /usr/local/bin/auto-cpufreq
sudo rm -vf /usr/local/bin/auto-cpufreq-gtk
sudo rm -vf /etc/init.d/auto-cpufreq
sudo rm -rvf /usr/local/lib/python3.13/dist-packages/auto_cpufreq
sudo rm -rvf /usr/local/lib/python3.13/dist-packages/auto_cpufreq-1.dist-info
sudo rm -rvf /usr/local/share/auto-cpufreq
