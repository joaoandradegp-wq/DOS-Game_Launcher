#!/bin/bash

set -e

chmod +x install_qwsv230.sh

echo "=========================================="
echo " QWSV 2.30 - QuakeWorld 1998"
echo " Linux Mint / Ubuntu"
echo "=========================================="

SERVER_DIR="$HOME/Deimos/QuakeServer"
GAME_DIR="$SERVER_DIR/qw"
PORT="28501"

echo
echo "[1/7] Habilitando arquitetura i386..."
sudo dpkg --add-architecture i386

echo
echo "[2/7] Atualizando repositórios..."
sudo apt update

echo
echo "[3/7] Instalando compatibilidade 32-bit..."
sudo apt install -y libc6:i386

echo
echo "[4/7] Criando diretórios..."
mkdir -p "$SERVER_DIR"
mkdir -p "$GAME_DIR"

echo
echo "[5/7] Verificando QWSV..."

if [ ! -f "$SERVER_DIR/qwsv" ]; then
    echo
    echo "ERRO: o arquivo qwsv não foi encontrado."
    echo
    echo "Coloque o QWSV 2.30 Linux em:"
    echo "$SERVER_DIR/qwsv"
    echo
    exit 1
fi

chmod +x "$SERVER_DIR/qwsv"

echo
echo "[6/7] Verificando arquivos do servidor..."

if [ ! -f "$GAME_DIR/server.cfg" ]; then
    echo
    echo "AVISO: server.cfg não encontrado."
    echo
    echo "Copie o server.cfg do seu servidor QuakeWorld 2.30"
    echo "para:"
    echo "$GAME_DIR/server.cfg"
    echo
fi

if [ ! -d "$GAME_DIR/maps" ]; then
    echo
    echo "AVISO: diretório maps não encontrado."
    echo
    echo "Copie os mapas do servidor antigo para:"
    echo "$GAME_DIR/maps/"
    echo
fi

echo
echo "[7/7] Configuração concluída!"
echo
echo "Diretório:"
echo "  $SERVER_DIR"
echo
echo "Game directory:"
echo "  $GAME_DIR"
echo
echo "Porta:"
echo "  $PORT"
echo
echo "Para iniciar o servidor:"
echo
echo "  cd $SERVER_DIR"
echo "  ./qwsv -port $PORT"
echo
echo "=========================================="
echo " QWSV 2.30 pronto!"
echo "=========================================="
