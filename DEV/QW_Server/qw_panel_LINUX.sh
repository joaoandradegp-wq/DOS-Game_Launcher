#!/bin/bash
set -e

# ----------------------------------------------------------------------
# Build do launcher para Linux
# ----------------------------------------------------------------------

echo "Verificando dependências..."

if ! command -v python3 &> /dev/null; then
    echo "ERRO: python3 não encontrado. Instale com: sudo apt install python3"
    exit 1
fi

if ! python3 -c "import tkinter" &> /dev/null; then
    echo "ERRO: módulo tkinter não encontrado."
    echo "Instale com: sudo apt install python3-tk"
    exit 1
fi

if ! python3 -m PyInstaller --version &> /dev/null; then
    echo "ERRO: PyInstaller não encontrado."
    echo "Instale com: pip3 install pyinstaller"
    exit 1
fi

echo "Compilando Quake Server Panel..."

python3 -m PyInstaller \
    qw_panel.py \
    --onefile \
    --noconsole \
    --name qw_panel \
    --clean \
    --noupx

echo ""
echo "Build concluído!"
echo "Executável disponível em: dist/launcher/launcher"
