#!/usr/bin/env bash

src_dir="$HOME/src/emacs-29.4"

if [ -e "$src_dir" ]; then
  (
    cd "$src_dir"
    sudo make install
  )
  sudo rm -rf /usr/local/bin/emacs
  sudo tee /usr/local/bin/emacs > /dev/null <<'EOF'
#!/usr/bin/env bash

# 強制 WebKit 停用 compositing mode（避免 GLX crash）
export WEBKIT_DISABLE_COMPOSITING_MODE=1

# 可選：改 WebKit 信號，避免 JSC 與 Emacs 衝突
export JSC_SIGNAL_FOR_GC=34

# 這裡指向你實際的 Emacs 可執行檔
EMACS_BIN="/usr/local/bin/emacs-29.4"

# 將所有命令列參數傳給 Emacs
exec "$EMACS_BIN" "$@"
EOF
  sudo chmod +x /usr/local/bin/emacs
fi
