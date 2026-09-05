#!/bin/bash

set -e

echo "=========================================="
echo " QWSV 2.30 - QuakeWorld 1998"
echo " Linux Mint / Ubuntu"
echo "=========================================="

SERVER_DIR="$HOME/Deimos/QuakeServer"
GAME_DIR="$SERVER_DIR/qw"
ID1_DIR="$SERVER_DIR/id1"
PORT="28501"

QWSV_URL="https://dukeworld.duke4.net/telefragged/quake/quakeworld/unix/qwsv-2.30-glibc-i386-unknown-linux2.0.tar.gz"
QWSV_ARCHIVE="$SERVER_DIR/qwsv-2.30-glibc-i386-unknown-linux2.0.tar.gz"

echo
echo "[1/7] Enabling i386 architecture..."
sudo dpkg --add-architecture i386

echo
echo "[2/7] Updating repositories..."
sudo apt update

echo
echo "[3/7] Installing 32-bit compatibility..."
sudo apt install -y libc6:i386 wget tar

echo
echo "[4/7] Creating server directories..."

mkdir -p "$SERVER_DIR"
mkdir -p "$GAME_DIR"
mkdir -p "$ID1_DIR"

echo
echo "[5/7] Installing QWSV 2.30..."

if [ -f "$SERVER_DIR/qwsv" ]; then

    echo "QWSV 2.30 is already installed:"
    echo "$SERVER_DIR/qwsv"

else

    echo
    echo "Downloading QWSV 2.30 for Linux..."

    wget -O "$QWSV_ARCHIVE" "$QWSV_URL"

    echo
    echo "Extracting QWSV 2.30..."

    tar -xzf "$QWSV_ARCHIVE" -C "$SERVER_DIR"

    chmod +x "$SERVER_DIR/qwsv"

    echo
    echo "QWSV 2.30 installed successfully!"

fi

echo
echo "[6/7] Checking Quake game files..."

if [ ! -f "$ID1_DIR/pak0.pak" ]; then
    echo
    echo "WARNING: pak0.pak was not found."
    echo
    echo "Copy your legally obtained Quake pak0.pak to:"
    echo "$ID1_DIR/pak0.pak"
    echo
fi

if [ ! -f "$ID1_DIR/pak1.pak" ]; then
    echo
    echo "WARNING: pak1.pak was not found."
    echo
    echo "Copy your legally obtained Quake pak1.pak to:"
    echo "$ID1_DIR/pak1.pak"
    echo
fi

echo
echo "[7/7] Installation completed!"
echo
echo "=========================================="
echo " QWSV 2.30 is ready!"
echo "=========================================="
echo
echo "Server directory:"
echo "  $SERVER_DIR"
echo
echo "QWSV executable:"
echo "  $SERVER_DIR/qwsv"
echo
echo "Quake game files:"
echo "  $ID1_DIR/"
echo
echo "QuakeWorld files:"
echo "  $GAME_DIR/"
echo
echo "Default port:"
echo "  $PORT"
echo
echo "=========================================="
echo " REQUIRED GAME FILES"
echo "=========================================="
echo
echo "Copy your legally obtained Quake files:"
echo
echo "  $ID1_DIR/pak0.pak"
echo "  $ID1_DIR/pak1.pak"
echo
echo "=========================================="
echo
echo "To start the server:"
echo
echo "  cd $SERVER_DIR"
echo "  ./qwsv -port $PORT"
echo
echo "=========================================="
echo " QWSV 2.30 - QuakeWorld 1998"
echo "=========================================="
