#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import ctypes
import json
import os
import sys
import urllib.error
import urllib.request

OWNER = "joaoandradegp-wq"
REPO = "DOS-Game_Launcher"
BRANCH = "main"
PASTA_REPO = "CONFIG/skin"

API_URL = f"https://api.github.com/repos/{OWNER}/{REPO}/contents/{PASTA_REPO}?ref={BRANCH}"
HEADERS = {
    "User-Agent": "DGL-Skin-Downloader",
    "Accept": "application/vnd.github+json",
}
TIMEOUT = 30
TITULO = "DOS Game Launcher"

MB_OK = 0x00
MB_ICONERROR = 0x10
MB_ICONWARNING = 0x30
MB_ICONINFORMATION = 0x40
MB_TOPMOST = 0x40000

MSG = {
    "bra": {
        "erro_403": "Limite de requisições da API do GitHub atingido (erro 403).\nTente novamente mais tarde.",
        "erro_http": "Erro HTTP ao listar a pasta de skins: {code} {reason}",
        "erro_listar": "Erro ao listar a pasta de skins:\n{err}",
        "erro_resposta": "Resposta inesperada da API do GitHub.",
        "erro_pasta": "Não foi possível criar/acessar a pasta de destino:\n{err}",
        "sem_novas": "Não existem novas Skins para atualizar.",
        "baixadas": "Foram baixadas {n} skins novas.",
        "falharam": "{n} arquivo(s) falharam ao baixar:\n{lista}",
    },
    "eua": {
        "erro_403": "GitHub API rate limit reached (error 403).\nPlease try again later.",
        "erro_http": "HTTP error while listing the skins folder: {code} {reason}",
        "erro_listar": "Error while listing the skins folder:\n{err}",
        "erro_resposta": "Unexpected response from the GitHub API.",
        "erro_pasta": "Could not create/access the destination folder:\n{err}",
        "sem_novas": "There are no new Skins to update.",
        "baixadas": "{n} new skins were downloaded.",
        "falharam": "{n} file(s) failed to download:\n{lista}",
    },
}


def show_message(texto: str, icone: int = MB_ICONINFORMATION) -> None:
    """Equivalente ao ShowMessage do Delphi (MessageBox do Windows)."""
    try:
        ctypes.windll.user32.MessageBoxW(0, texto, TITULO, MB_OK | icone | MB_TOPMOST)
    except Exception:
        # Fora do Windows (ou sem GUI): cai para o terminal
        try:
            print(texto)
        except Exception:
            pass


class Parser(argparse.ArgumentParser):
    """ArgumentParser que mostra erros/ajuda em janela, não no terminal."""

    def _print_message(self, message, file=None):
        if message:
            show_message(message, MB_ICONINFORMATION)

    def error(self, message):
        show_message(f"{self.format_usage()}\n{message}", MB_ICONERROR)
        sys.exit(2)


def http_get(url: str) -> bytes:
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
        return resp.read()


def listar_pcx(m: dict) -> list:
    """Retorna a lista de arquivos .pcx da pasta (via API do GitHub)."""
    dados = json.loads(http_get(API_URL).decode("utf-8"))
    if not isinstance(dados, list):
        raise RuntimeError(m["erro_resposta"])
    return [
        item for item in dados
        if item.get("type") == "file" and item.get("name", "").lower().endswith(".pcx")
    ]


def main() -> int:
    parser = Parser(
        description="Baixa os .pcx de CONFIG/skin do DOS-Game_Launcher. / "
                    "Downloads the .pcx files from CONFIG/skin of DOS-Game_Launcher."
    )
    parser.add_argument("destino", help="Pasta de destino / Destination folder")
    parser.add_argument(
        "idioma",
        nargs="?",
        default="bra",
        type=str.lower,
        choices=["bra", "eua"],
        help="bra = Português | eua = English (padrão/default: bra)",
    )
    args = parser.parse_args()

    m = MSG[args.idioma]
    destino = os.path.abspath(args.destino)

    try:
        os.makedirs(destino, exist_ok=True)
        existentes = {nome.lower() for nome in os.listdir(destino)}
    except Exception as e:
        show_message(m["erro_pasta"].format(err=e), MB_ICONERROR)
        return 1

    try:
        arquivos = listar_pcx(m)
    except urllib.error.HTTPError as e:
        if e.code == 403:
            show_message(m["erro_403"], MB_ICONERROR)
        else:
            show_message(m["erro_http"].format(code=e.code, reason=e.reason), MB_ICONERROR)
        return 1
    except Exception as e:
        show_message(m["erro_listar"].format(err=e), MB_ICONERROR)
        return 1

    # Verifica quais skins ainda não existem na pasta de destino
    novos = [a for a in arquivos if a["name"].lower() not in existentes]

    if not novos:
        show_message(m["sem_novas"], MB_ICONINFORMATION)
        return 0

    ok = 0
    falhas = []
    for item in novos:
        nome = item["name"]
        url = item.get("download_url")
        if not url:
            falhas.append(nome)
            continue
        try:
            conteudo = http_get(url)
            with open(os.path.join(destino, nome), "wb") as f:
                f.write(conteudo)
            ok += 1
        except Exception:
            falhas.append(nome)

    if falhas:
        texto = m["baixadas"].format(n=ok) + "\n\n" + m["falharam"].format(
            n=len(falhas), lista="\n".join(falhas)
        )
        show_message(texto, MB_ICONWARNING)
        return 2

    show_message(m["baixadas"].format(n=ok), MB_ICONINFORMATION)
    return 0


if __name__ == "__main__":
    sys.exit(main())
