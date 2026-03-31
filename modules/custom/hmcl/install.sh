#!/usr/bin/env bash

LOCAL_DESKTOP_DIR="$HOME/.local/share/applications"
LOCAL_ICON_DIR="$HOME/.local/share/icons/hicolor/128x128/apps"
HMCL_OPT_DIR="$HOME/.local/opt/hmcl"
HMCL_VERSION="3.12.2"
HMCL_JAR_DIR="$HMCL_OPT_DIR/HMCL-$HMCL_VERSION.jar"
HMCL_ICON_DIR="$LOCAL_ICON_DIR/hmcl.png"
HMCL_DESKTOP_DIR="$LOCAL_DESKTOP_DIR/HMCL.desktop"
HMCL_BIN_DIR="$HOME/.local/bin/hmcl"
JAVAFX_DIR="$HOME/.local/opt/hmcl/hmcl-javafx"
JAVAFX_VERSION="21.0.10"
JAVAFX_BASE_DIR="$JAVAFX_DIR/javafx-base-${JAVAFX_VERSION}-linux.jar"
JAVAFX_GRAPHICS_DIR="$JAVAFX_DIR/javafx-graphics-${JAVAFX_VERSION}-linux.jar"
JAVAFX_CONTROLS_DIR="$JAVAFX_DIR/javafx-controls-${JAVAFX_VERSION}-linux.jar"


if [ ! -e "$LOCAL_DESKTOP_DIR" ]; then
  mkdir -p $LOCAL_DESKTOP_DIR
fi
if [ ! -e "$LOCAL_ICON_DIR" ]; then
  mkdir -p $LOCAL_ICON_DIR
fi
if [ ! -e "$HMCL_OPT_DIR" ]; then
  mkdir -p $HMCL_OPT_DIR
fi
if [ ! -e "$JAVAFX_DIR" ]; then
  mkdir -p $JAVAFX_DIR
fi

if [ ! -e "$JAVAFX_BASE_DIR" ]; then
  wget "https://repo1.maven.org/maven2/org/openjfx/javafx-base/${JAVAFX_VERSION}/javafx-base-${JAVAFX_VERSION}-linux.jar" \
    -O "$JAVAFX_BASE_DIR"
fi
if [ ! -e "$JAVAFX_GRAPHICS_DIR" ]; then 
  wget "https://repo1.maven.org/maven2/org/openjfx/javafx-graphics/${JAVAFX_VERSION}/javafx-graphics-${JAVAFX_VERSION}-linux.jar" \
    -O "$JAVAFX_GRAPHICS_DIR"
fi
if [ ! -e "$JAVAFX_CONTROLS_DIR" ]; then
  wget "https://repo1.maven.org/maven2/org/openjfx/javafx-controls/${JAVAFX_VERSION}/javafx-controls-${JAVAFX_VERSION}-linux.jar" \
    -O "$JAVAFX_CONTROLS_DIR" 
fi

if [ ! -e "$HMCL_JAR_DIR" ]; then
  wget "https://github.com/HMCL-dev/HMCL/releases/download/v${HMCL_VERSION}/HMCL-${HMCL_VERSION}.jar" -O "$HMCL_JAR_DIR"
fi
if [ ! -e "$HMCL_ICON_DIR" ]; then
  wget "https://raw.githubusercontent.com/HMCL-dev/HMCL/refs/heads/main/HMCL/image/hmcl.png" -O "$HMCL_ICON_DIR"
fi

cat > "$HMCL_DESKTOP_DIR" << EOF
[Desktop Entry]
Type=Application
Name=HMCL
Exec=hmcl
Icon=hmcl
Comment=Hello Minecraft! Launcher
Categories=Game;
EOF

cat > "$HMCL_BIN_DIR" << EOF
#!/usr/bin/env bash
exec java \
  --module-path $JAVAFX_DIR \
  --add-modules javafx.controls \
  -Dprism.verbose=true \
  -Djavafx.verbose=true \
  -Dprism.forceGPU=true \
  -jar $HMCL_JAR_DIR \
  "\$@"
EOF
chmod +x "$HMCL_BIN_DIR"
