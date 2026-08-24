#!/bin/bash

SERVER_DIR="$HOME/Deimos/QuakeServer"
PORT="28501"

cd "$SERVER_DIR" || exit 1

chmod +x start_qwsv230.sh

echo "=========================================="
echo " QuakeWorld Server 2.30"
echo " Porta: $PORT"
echo "=========================================="

exec ./qwsv -port "$PORT"
