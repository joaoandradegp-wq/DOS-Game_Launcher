import os
import sys
import ctypes
import subprocess

# ================= CONFIG =================

BASE_DIR = os.path.dirname(os.path.abspath(sys.argv[0]))
EXE_NAME = "DOS_GAMES.exe"
BASE_PARAM = "phobos"
INI_FILE = os.path.join(BASE_DIR, "dos.ini")

# Portuguese LCIDs
PT_LCIDS = {0x0416, 0x0816}  # pt-BR, pt-PT

# ==========================================

def is_windows_portuguese():
    """
    Detecta se o idioma da UI do Windows é Português
    """
    try:
        lang_id = ctypes.windll.kernel32.GetUserDefaultUILanguage()
        return lang_id in PT_LCIDS
    except:
        return False


def run_as_admin(exe_path, params):
    ctypes.windll.shell32.ShellExecuteW(
        None,
        "runas",
        exe_path,
        params,
        None,
        1  # SW_SHOWNORMAL
    )


def run_normal(exe_path, params):
    subprocess.Popen([exe_path, params], cwd=BASE_DIR)


def main():
    exe_path = os.path.join(BASE_DIR, EXE_NAME)

    if not os.path.exists(exe_path):
        print("Executável não encontrado.")
        sys.exit(1)

    # Monta parâmetros dinamicamente
    params = BASE_PARAM

    if not is_windows_portuguese():
        params += " usa"  # phobos usa

    # Se não existir ini → executar como admin
    if not os.path.exists(INI_FILE):
        run_as_admin(exe_path, params)
    else:
        run_normal(exe_path, params)

    sys.exit(0)


if __name__ == "__main__":
    main()
