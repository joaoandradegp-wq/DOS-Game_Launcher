import requests
import base64
import json
import os
import sys
import subprocess
import ctypes
from packaging.version import Version

# ================= CONFIG =================

def get_current_version():
    if len(sys.argv) > 1:
        return sys.argv[1]
    return "0.0"

API_URL = (
    "https://api.github.com/repos/"
    "joaoandradegp-wq/DOS-Game_Launcher/"
    "contents/update.json"
)

HEADERS = {
    "User-Agent": "SRT-Adjuster-Updater/1.9",
    "Accept": "application/vnd.github.v3+json"
}

TEMP_DIR = "temp"

BASE_DIR = os.path.dirname(os.path.abspath(sys.argv[0]))

# ================= UX =================

def msgbox(text, title="DOS Game Launcher", icon=64):
    ctypes.windll.user32.MessageBoxW(None, text, title, icon)

def ask_update(version):
    return ctypes.windll.user32.MessageBoxW(
        None,
        f"Nova versão {version} disponível.\n\nDeseja atualizar agora?",
        "Atualização disponível",
        4 | 64
    ) == 6

# ================= UPDATE CHECK =================

def check_update(current_version):
    r = requests.get(API_URL, headers=HEADERS, timeout=10)
    r.raise_for_status()

    data = r.json()
    content_json = base64.b64decode(data["content"]).decode("utf-8")
    update_info = json.loads(content_json)

    latest_version = update_info["version"].strip()
    download_url = update_info["url"]

    if Version(latest_version) > Version(current_version.strip()):
        return True, latest_version, download_url

    return False, current_version, None

# ================= DOWNLOAD =================

def download(url, dest):
    with requests.get(url, stream=True, timeout=60) as r:
        r.raise_for_status()
        with open(dest, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                if chunk:
                    f.write(chunk)

# ================= PROCESS CONTROL =================

def kill_process(process_name):
    subprocess.call(
        ["taskkill", "/f", "/im", process_name],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )

# ================= MAIN =================

if __name__ == "__main__":
    try:
        CURRENT_VERSION = get_current_version()

        has_update, latest_version, url = check_update(CURRENT_VERSION)

        launcher_path = os.path.join(BASE_DIR, "launcher.exe")

        # ✅ SEM UPDATE → abre launcher
        if not has_update:
            subprocess.Popen(launcher_path, creationflags=subprocess.DETACHED_PROCESS)
            sys.exit(0)

        # ✅ TEM UPDATE MAS USUÁRIO NEGOU → abre launcher
        if not ask_update(latest_version):
            subprocess.Popen(launcher_path, creationflags=subprocess.DETACHED_PROCESS)
            sys.exit(0)

        # 🔥 FECHAR O JOGO ANTES DE ATUALIZAR
        kill_process("DOS_GAMES.exe")

        os.makedirs(TEMP_DIR, exist_ok=True)

        installer_name = f"DGL_Setup{latest_version}.exe"
        installer_path = os.path.join(BASE_DIR, TEMP_DIR, installer_name)

        msgbox("Baixando atualização...\nAguarde.")

        download(url, installer_path)

        subprocess.Popen(
            installer_path,
            creationflags=subprocess.DETACHED_PROCESS
        )

        sys.exit(0)

    except Exception as e:
        msgbox(f"Erro ao verificar atualização:\n{str(e)}", "Erro", 16)
        sys.exit(1)
