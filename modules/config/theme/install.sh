#!/usr/bin/env bash

mkdir -p $HOME/.config/gtk-3.0
cat > $HOME/.config/gtk-3.0/settings.ini <<'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-cursor-theme-name=Adwaita
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Papirus
EOF

mkdir -p $HOME/.config/gtk-4.0
cat > $HOME/.config/gtk-4.0/settings.ini <<'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-cursor-theme-name=Adwaita
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Papirus
EOF
