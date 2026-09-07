#!/bin/bash
set -e

# ----------------------------------------------------------------------
# QW Server Panel - Installer for Linux
# Installs QWSV 2.30, then downloads the panel source code, builds it
# with PyInstaller and installs the resulting binary
# ----------------------------------------------------------------------

PANEL_REPO_RAW="https://raw.githubusercontent.com/joaoandradegp-wq/DOS-Game_Launcher/refs/heads/main/DEV/qw_server"
PANEL_PY_FILE="qw_panel.py"
INSTALL_DIR="$HOME/.local/bin"

DEFAULT_FOLDER_NAME="QuakeServer"
read -p "Folder name to create at $HOME/ [$DEFAULT_FOLDER_NAME]: " FOLDER_NAME
FOLDER_NAME="${FOLDER_NAME:-$DEFAULT_FOLDER_NAME}"

SERVER_DIR="$HOME/$FOLDER_NAME"
ID1_DIR="$SERVER_DIR/id1"
QW_DIR="$SERVER_DIR/qw"
QWSV_URL="https://dukeworld.duke4.net/telefragged/quake/quakeworld/unix/qwsv-2.30-glibc-i386-unknown-linux2.0.tar.gz"

WORKDIR="$(mktemp -d)"

cleanup() {
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

echo "=== QW Server Panel - Installer ==="
echo ""
echo "Checking dependencies..."

if ! command -v python3 &> /dev/null; then
    echo "ERROR: python3 not found. Install it with: sudo apt install python3"
    exit 1
fi

if ! python3 -c "import tkinter" &> /dev/null; then
    echo "ERROR: tkinter module not found."
    echo "Install it with: sudo apt install python3-tk"
    exit 1
fi

if ! command -v wget &> /dev/null; then
    echo "ERROR: wget not found. Install it with: sudo apt install wget"
    exit 1
fi

if ! python3 -m PyInstaller --version &> /dev/null; then
    echo "PyInstaller not found. Installing for the current user..."
    pip3 install --user pyinstaller
fi

# ----------------------------------------------------------------------
# QWSV 2.30
# ----------------------------------------------------------------------
if [ -f "$SERVER_DIR/qwsv" ]; then
    echo ""
    echo "QWSV 2.30 already installed at $SERVER_DIR/qwsv, skipping."
else
    echo ""
    echo "Setting up i386 support for QWSV..."
    sudo dpkg --add-architecture i386
    sudo apt update
    sudo apt install -y libc6:i386

    echo ""
    echo "Downloading QWSV 2.30..."
    mkdir -p "$SERVER_DIR" "$ID1_DIR" "$QW_DIR"
    wget -O "$WORKDIR/qwsv230.tar.gz" "$QWSV_URL"
    tar -xzf "$WORKDIR/qwsv230.tar.gz" -C "$SERVER_DIR"
    chmod +x "$SERVER_DIR/qwsv"
fi

if [ ! -f "$ID1_DIR/pak0.pak" ] || [ ! -f "$ID1_DIR/pak1.pak" ]; then
    echo ""
    echo "WARNING: copy your legally obtained pak0.pak and pak1.pak to:"
    echo "  $ID1_DIR/"
fi

# ----------------------------------------------------------------------
# Panel (qw_panel.py -> binary via PyInstaller)
# ----------------------------------------------------------------------
echo ""
echo "Downloading panel source code..."
curl -fsSL "$PANEL_REPO_RAW/$PANEL_PY_FILE" -o "$WORKDIR/$PANEL_PY_FILE"

cd "$WORKDIR"

echo "Building..."
python3 -m PyInstaller \
    "$PANEL_PY_FILE" \
    --onefile \
    --noconsole \
    --name qw_panel \
    --clean \
    --noupx

echo ""
echo "Installing binary to $INSTALL_DIR ..."
mkdir -p "$INSTALL_DIR"
cp "dist/qw_panel" "$INSTALL_DIR/qw_panel"
chmod +x "$INSTALL_DIR/qw_panel"

echo ""
echo "Installation complete!"
echo "Panel binary: $INSTALL_DIR/qw_panel"
echo "QWSV server:  $SERVER_DIR/qwsv"

# ----------------------------------------------------------------------
# Desktop icon
# ----------------------------------------------------------------------
DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
mkdir -p "$DESKTOP_DIR"
DESKTOP_FILE="$DESKTOP_DIR/qw_panel.desktop"

cat > "$DESKTOP_FILE" << EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=QuakeWorld Server
Comment=QuakeWorld Server
Exec="$INSTALL_DIR/qw_panel"
Icon=uninterruptible-power-supply
Terminal=false
Categories=Utility;
EOL

chmod +x "$DESKTOP_FILE"
# Marks the .desktop file as trusted so it can be launched with a double-click
# on file managers that check this (Nautilus/GNOME, Cinnamon/Nemo).
gio set "$DESKTOP_FILE" metadata::trusted true 2>/dev/null || true

echo "Desktop icon: $DESKTOP_FILE"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "WARNING: $INSTALL_DIR is not in your PATH."
    echo "Add this line to your ~/.bashrc (or ~/.profile):"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "Then run 'qw_panel' from anywhere."
else
    echo "Run it with: qw_panel"
fi
