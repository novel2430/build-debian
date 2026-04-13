#!/usr/bin/env zsh

download_src="/tmp/spotify-client_amd64.deb"

if [ ! -e "$download_src" ]; then
	# Installing
	wget "http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.2.86.502.g8cd7fb22_amd64.deb" -O $download_src
fi
sudo dpkg -i "$download_src"

touch /tmp/Spotify.desktop
cat > /tmp/Spotify.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Spotify
GenericName=Music Player
Icon=spotify-client
TryExec=spotify
Exec=spotify %U
Terminal=false
MimeType=x-scheme-handler/spotify;
Categories=Audio;Music;Player;AudioVideo;
StartupWMClass=Spotify
EOF
sudo cp --verbose /tmp/Spotify.desktop /usr/local/share/applications/Spotify.desktop
