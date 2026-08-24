#!/bin/bash

set -e

echo "=========================================="
echo " QWSV 2.30 - QuakeWorld 1998"
echo " Linux Mint / Ubuntu"
echo "=========================================="

SERVER_DIR="$HOME/Deimos/QuakeServer"
GAME_DIR="$SERVER_DIR/qw"
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
echo "[4/7] Creating directories..."
mkdir -p "$SERVER_DIR"
mkdir -p "$GAME_DIR"

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
echo "[6/7] Checking server files..."

if [ ! -f "$GAME_DIR/server.cfg" ]; then
    echo
    echo "WARNING: server.cfg was not found."
    echo
    echo "Copy your QuakeWorld 2.30 server.cfg to:"
    echo "$GAME_DIR/server.cfg"
    echo
fi

if [ ! -d "$GAME_DIR/maps" ]; then
    echo
    echo "WARNING: maps directory was not found."
    echo
    echo "Copy your QuakeWorld maps to:"
    echo "$GAME_DIR/maps/"
    echo
fi

echo
echo "[7/7] Configuration completed!"
echo
echo "=========================================="
echo " QWSV 2.30 is ready!"
echo "=========================================="
echo
echo "Executable:"
echo "  $SERVER_DIR/qwsv"
echo
echo "Game directory:"
echo "  $GAME_DIR"
echo
echo "Default port:"
echo "  $PORT"
echo
echo "To start the server:"
echo
echo "  cd $SERVER_DIR"
echo "  ./qwsv -port $PORT"
echo
echo "=========================================="
