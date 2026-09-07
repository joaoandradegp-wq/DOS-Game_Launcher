#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Painel de controle para servidor QuakeWorld (qwsv)
====================================================

Funciona tanto em Linux quanto em Windows.

Permite:
  - Editar o server.cfg por uma tela (sem mexer no arquivo na mão)
  - Escolher o mapa inicial (apenas mapas de Quake, agrupados por episódio)
  - Iniciar / Parar o servidor sem mostrar o console (log fica escondido
    em arquivo, só aparece se você clicar em "Ver log")
  - Indicador de status ONLINE / OFFLINE
  - Lista lateral com os jogadores conectados (consulta via protocolo
    QuakeWorld "status" por UDP)
  - Administração ao vivo via RCON (servidor continua rodando):
    admin/url do serverinfo, allow_download, troca de mapa (changelevel),
    chat (say), restart, quit, e kick/ban clicando com o botão direito
    em cima de um jogador na lista

Requisitos:
  Linux:   sudo apt install python3-tk
  Windows: o Tkinter já vem junto com o instalador oficial do Python

Uso:
  python3 quake_panel.py
"""

import json
import locale
import os
import platform
import re
import signal
import socket
import subprocess
import sys
import time
import tkinter as tk
from tkinter import ttk, messagebox, filedialog

IS_WINDOWS = platform.system() == "Windows"


# ----------------------------------------------------------------------
# Internacionalização (PT-BR / English)
# ----------------------------------------------------------------------
#
# Regra: se o idioma do sistema operacional for Português do Brasil
# (pt_BR), o painel fala PT-BR. Qualquer outro idioma do SO -> Inglês.

def detect_system_language():
    """Detecta o idioma do sistema operacional (Windows ou Linux) e
    devolve 'pt_BR' ou 'en'. Em caso de dúvida, cai para 'en'."""
    candidates = []

    if IS_WINDOWS:
        try:
            import ctypes
            LOCALE_SNAME = 0x5c  # ex: "pt-BR", "en-US"
            lcid = ctypes.windll.kernel32.GetUserDefaultUILanguage()
            buf = ctypes.create_unicode_buffer(85)
            if ctypes.windll.kernel32.GetLocaleInfoW(lcid, LOCALE_SNAME, buf, 85):
                candidates.append(buf.value)
        except Exception:
            pass
    else:
        try:
            lang, _ = locale.getlocale()
            if lang:
                candidates.append(lang)
        except Exception:
            pass

    # variáveis de ambiente (Linux/macOS, e fallback geral)
    for var in ("LC_ALL", "LC_MESSAGES", "LANG", "LANGUAGE"):
        val = os.environ.get(var)
        if val:
            candidates.append(val)

    for c in candidates:
        norm = c.strip().lower().replace("-", "_")
        if norm.startswith("pt_br"):
            return "pt_BR"

    return "en"


LANG = detect_system_language()

STRINGS = {
    "panel_title": {"pt_BR": "Painel", "en": "Panel"},
    "tab_start": {"pt_BR": "Início", "en": "Start"},
    "tab_running": {"pt_BR": "Servidor em Execução", "en": "Running Server"},
    "tab_settings": {"pt_BR": "Configurações", "en": "Settings"},
    "btn_start": {"pt_BR": " ▶ Iniciar ", "en": " ▶ Start "},
    "btn_stop": {"pt_BR": " ■ Parar ", "en": " ■ Stop "},
    "btn_view_log": {"pt_BR": "Ver log", "en": "View log"},
    "online_players": {"pt_BR": "Jogadores online", "en": "Online Players"},
    "players_count": {"pt_BR": "{} jogador(es)", "en": "{} player(s)"},
    "btn_refresh": {"pt_BR": "Atualizar", "en": "Refresh"},
    "label_hostname": {"pt_BR": "Nome do Servidor", "en": "Server Name"},
    "label_teamplay": {"pt_BR": "Teamplay (0-3)", "en": "Teamplay (0-3)"},
    "label_maxclients": {"pt_BR": "Máx. Jogadores", "en": "Max. Players"},
    "label_maxspectators": {"pt_BR": "Máx. Espectadores", "en": "Max. Spectators"},
    "label_fraglimit": {"pt_BR": "Limite de Frags", "en": "Frag Limit"},
    "label_timelimit": {"pt_BR": "Limite de Tempo (minutos)", "en": "Time Limit (minutes)"},
    "label_password": {"pt_BR": "Senha do Servidor", "en": "Server Password"},
    "label_rcon_password": {"pt_BR": "Senha de RCON (Remoto)", "en": "RCON Password (Remote)"},
    "label_admin_email": {"pt_BR": "Informações de Contato", "en": "Contact Info"},
    "label_admin_url": {"pt_BR": "Endereço WEB", "en": "Web Address"},
    "check_allow_download": {"pt_BR": "Permitir download de mapas/arquivos", "en": "Allow downloading maps/files"},
    "check_samelevel": {"pt_BR": "Repetir mesmo mapa ao terminar", "en": "Repeat same map when it ends"},
    "check_noexit": {"pt_BR": "Não voltar ao MENU ao terminar a partida", "en": "Don't return to MENU when the match ends"},
    "label_server_dir": {"pt_BR": "Diretório do Servidor", "en": "Server Directory"},
    "label_executable": {"pt_BR": "Executável", "en": "Executable"},
    "label_port": {"pt_BR": "Porta", "en": "Port"},
    "label_cfg_path": {"pt_BR": "Caminho do arquivo server.cfg", "en": "Path to server.cfg file"},
    "btn_browse": {"pt_BR": "Procurar...", "en": "Browse..."},
    "btn_save": {"pt_BR": "Salvar", "en": "Save"},
    "filetype_executable": {"pt_BR": "Executável", "en": "Executable"},
    "filetype_all_files": {"pt_BR": "Todos os arquivos", "en": "All files"},
    "filetype_cfg": {"pt_BR": "Arquivo de configuração", "en": "Configuration file"},
    "box_server_startup_info": {"pt_BR": "Informações de Início do Servidor", "en": "Server Startup Info"},
    "btn_apply": {"pt_BR": "Aplicar", "en": "Apply"},
    "box_change_map": {"pt_BR": "Trocar Mapa", "en": "Change Map"},
    "label_episode": {"pt_BR": "Episódio", "en": "Episode"},
    "label_map": {"pt_BR": "Mapa", "en": "Map"},
    "btn_change_map": {"pt_BR": "Trocar Mapa", "en": "Change Map"},
    "box_message_players": {"pt_BR": "Mensagem para os Jogadores", "en": "Message to Players"},
    "btn_send": {"pt_BR": "Enviar", "en": "Send"},
    "err_missing_fields": {"pt_BR": "Preencha os campos obrigatórios antes de salvar:\n- ",
                            "en": "Please fill in the required fields before saving:\n- "},
    "info_updated": {"pt_BR": "Informações atualizadas!", "en": "Information updated!"},
    "err_port_unavailable": {"pt_BR": "Porta indisponível.", "en": "Port unavailable."},
    "err_invalid_dir": {"pt_BR": "Diretório informado inválido:\n{}", "en": "Invalid directory provided:\n{}"},
    "err_cannot_start": {"pt_BR": "Não é possível iniciar o servidor:\n{}", "en": "Unable to start the server:\n{}"},
    "err_save_cfg": {"pt_BR": "Erro ao salvar o arquivo server.cfg:\n{}", "en": "Error saving the server.cfg file:\n{}"},
    "err_open_log": {"pt_BR": "Não foi possível abrir o log:\n{}", "en": "Unable to open the log:\n{}"},
    "err_start_server": {"pt_BR": "Erro ao iniciar o Servidor:\n{}", "en": "Error starting the server:\n{}"},
    "info_no_server_running": {"pt_BR": "Nenhum Servidor em execução.", "en": "No server running."},
    "err_stop_process": {"pt_BR": "Não foi possível paralisar o processo {}:\n{}",
                          "en": "Unable to stop process {}:\n{}"},
    "info_no_log_yet": {"pt_BR": "Ainda não há log para mostrar.", "en": "There is no log to show yet."},
    "log_window_title": {"pt_BR": "Log do Servidor (somente leitura)", "en": "Server Log (read-only)"},
    "err_access_log": {"pt_BR": "Não foi possível acessar o log:\n{}", "en": "Unable to access the log:\n{}"},
    "err_rcon_no_password": {"pt_BR": "Defina uma senha de RCON na aba \"Início\" e inicie o servidor em seguida.",
                              "en": "Set an RCON password in the \"Start\" tab and then start the server."},
    "err_update_server_info": {"pt_BR": "Falha ao atualizar informações do Servidor:\n{}",
                                "en": "Failed to update server info:\n{}"},
    "info_updated_success": {"pt_BR": "Atualizado com sucesso!", "en": "Updated successfully!"},
    "warn_choose_map": {"pt_BR": "Escolha um Mapa.", "en": "Choose a Map."},
    "err_change_map": {"pt_BR": "Falha ao trocar o mapa:\n{}", "en": "Failed to change the map:\n{}"},
    "info_map_changed": {"pt_BR": "Mapa alterado para: {}", "en": "Map changed to: {}"},
    "err_send_message": {"pt_BR": "Falha ao enviar mensagem:\n{}", "en": "Failed to send message:\n{}"},
    "rcon_no_text": {"pt_BR": "(o servidor não devolveu texto)", "en": "(the server returned no text)"},
    "rcon_result_body": {"pt_BR": "{}\n\nResposta do servidor:\n{}", "en": "{}\n\nServer response:\n{}"},
    "menu_kick": {"pt_BR": "Kick {} (userid {})", "en": "Kick {} (userid {})"},
    "menu_kick_unavailable": {"pt_BR": "Kick indisponível (defina rcon_password)",
                               "en": "Kick unavailable (set rcon_password)"},
    "menu_ban": {"pt_BR": "Ban {} por IP ({})", "en": "Ban {} by IP ({})"},
    "menu_ban_unavailable": {"pt_BR": "Ban indisponível (defina rcon_password)",
                              "en": "Ban unavailable (set rcon_password)"},
    "err_kick": {"pt_BR": "Falha ao dar kick:\n{}", "en": "Failed to kick:\n{}"},
    "info_kick_sent": {"pt_BR": "Kick enviado para {}.", "en": "Kick sent to {}."},
    "err_ban": {"pt_BR": "Falha ao banir:\n{}", "en": "Failed to ban:\n{}"},
    "info_ip_banned": {"pt_BR": "IP {} banido (addip + writeip).", "en": "IP {} banned (addip + writeip)."},
    "no_name": {"pt_BR": "(sem nome)", "en": "(no name)"},
    "err_dir_not_exist": {"pt_BR": "Diretório do servidor não existe.", "en": "Server directory does not exist."},
    "err_id1_not_found": {"pt_BR": 'Pasta "id1" não encontrada em: {}', "en": 'The "id1" folder was not found in: {}'},
    "err_id1_read_fail": {"pt_BR": "Não consegui ler a pasta id1:\n{}", "en": "Could not read the id1 folder:\n{}"},
    "err_id1_no_pak": {"pt_BR": 'A pasta "id1" existe, mas não tem nenhum arquivo .pak dentro.',
                        "en": 'The "id1" folder exists, but has no .pak file inside.'},
    "cfg_comment_extra": {"pt_BR": "// linhas extras adicionadas manualmente",
                           "en": "// extra lines added manually"},
    "cfg_comment_startmap": {"pt_BR": "// mapa inicial escolhido no painel",
                              "en": "// starting map chosen in the panel"},
    "console_save_settings_fail": {"pt_BR": "Não foi possível salvar settings do painel:",
                                    "en": "Could not save the panel settings:"},
    "btn_standard_mode": {"pt_BR": "◱ Modo Padrão", "en": "◱ Standard Mode"},
    "btn_light_mode": {"pt_BR": "◱ Modo Light", "en": "◱ Light Mode"},
    "light_mode_title": {"pt_BR": "Servidor QuakeWorld", "en": "QuakeWorld Server"},
    "err_launch_requires_launcher": {
        "pt_BR": "Este programa deve ser iniciado pelo DOS Game Launcher.",
        "en": "This program must be started by the DOS Game Launcher."},
}


def T(key, *args):
    """Devolve a string traduzida para o idioma detectado do SO. Se
    houver argumentos, formata a string com eles (estilo str.format)."""
    entry = STRINGS.get(key, {})
    text = entry.get(LANG) or entry.get("en") or key
    if args:
        return text.format(*args)
    return text


# ----------------------------------------------------------------------
# Configuração do próprio painel (fica salva no seu $HOME/perfil,
# separada do server.cfg do jogo)
# ----------------------------------------------------------------------

APP_SETTINGS_FILE = os.path.join(os.path.expanduser("~"), ".qw_panel_settings.json")


def get_app_dir():
    """Diretório onde o programa está rodando de fato: pasta do .exe
    compilado (PyInstaller) ou pasta do script .py. Como o painel sempre
    fica na raiz da instalação do Quake, este é o valor certo para
    'Diretório do Servidor' por padrão."""
    if getattr(sys, "frozen", False):
        return os.path.dirname(os.path.abspath(sys.executable))
    return os.path.dirname(os.path.abspath(__file__))


def default_executable_name():
    return "qwsv.exe" if IS_WINDOWS else "./qwsv"


def find_executable_in(app_dir):
    """Procura o qwsv (ou qwsv.exe) direto na pasta raiz do programa. Se
    encontrar, usa esse; senão cai no nome padrão."""
    name = "qwsv.exe" if IS_WINDOWS else "qwsv"
    if os.path.isfile(os.path.join(app_dir, name)):
        return name if IS_WINDOWS else "./" + name
    return default_executable_name()


def build_default_settings():
    app_dir = get_app_dir()
    return {
        "server_dir": app_dir,
        "executable": find_executable_in(app_dir),
        "port": "28501",
        "cfg_relative_path": os.path.join("qw", "server.cfg"),
        "last_map": "start",
        # True só depois que o usuário salvar manualmente a aba
        # "Configurações" — enquanto for False, a pasta/executável sempre
        # são recalculados a partir de onde o programa está rodando agora,
        # mesmo que o json já exista (ex: o launcher foi movido de pasta)
        "server_dir_custom": False,
    }


def check_server_files(server_dir):
    """Confere se a pasta tem o mínimo necessário pro qwsv rodar (a pasta
    'id1' com pelo menos um arquivo .pak dentro). Devolve (ok, mensagem)."""
    if not server_dir or not os.path.isdir(server_dir):
        return False, T("err_dir_not_exist")

    id1_dir = os.path.join(server_dir, "id1")
    if not os.path.isdir(id1_dir):
        return False, T("err_id1_not_found", server_dir)

    try:
        paks = [f for f in os.listdir(id1_dir) if f.lower().endswith(".pak")]
    except Exception as e:
        return False, T("err_id1_read_fail", e)

    if not paks:
        return False, T("err_id1_no_pak")

    return True, ""

# ----------------------------------------------------------------------
# Mapas de Quake (episódio + capítulo), extraídos da sua lista.
# Cada episódio é (titulo, [(codigo_interno, nome_da_fase), ...])
# ----------------------------------------------------------------------

QUAKE_EPISODES = [
    ("Welcome to Quake", [
        ("start", "Introduction"),
    ]),
    ("Dimension of the Doomed", [
        ("e1m1", "The Slipgate Complex"),
        ("e1m2", "Castle of the Damned"),
        ("e1m3", "The Necropolis"),
        ("e1m4", "The Grisly Grotto"),
        ("e1m8", "Ziggurat Vertigo (Secret Level)"),
        ("e1m5", "Gloom Keep"),
        ("e1m6", "The Door to Chthon"),
        ("e1m7", "The House of Chthon"),
    ]),
    ("The Realm of Black Magic", [
        ("e2m1", "The Installation"),
        ("e2m2", "The Ogre Citadel"),
        ("e2m3", "The Crypt of Decay"),
        ("e2m7", "The Underearth (Secret Level)"),
        ("e2m4", "The Ebon Fortress"),
        ("e2m5", "The Wizard's Manse"),
        ("e2m6", "The Dismal Oubliette"),
    ]),
    ("The Netherworld", [
        ("e3m1", "Termination Central"),
        ("e3m2", "The Vaults of Zin"),
        ("e3m3", "The Tomb of Terror"),
        ("e3m4", "Satan's Dark Delight"),
        ("e3m7", "The Haunted Halls (Secret Level)"),
        ("e3m5", "The Wind Tunnels"),
        ("e3m6", "Chambers of Torment"),
    ]),
    ("The Elder World", [
        ("e4m1", "The Sewage System"),
        ("e4m2", "The Tower of Despair"),
        ("e4m3", "The Elder God Shrine"),
        ("e4m4", "The Palace of Hate"),
        ("e4m5", "Hell's Atrium"),
        ("e4m8", "The Nameless City (Secret Level)"),
        ("e4m6", "The Pain Maze"),
        ("e4m7", "Azure Agony"),
    ]),
    ("Final Level", [
        ("end", "Shub-Niggurath's Pit"),
    ]),
    ("DeathMatch Arena", [
        ("dm1", "Place of Two Deaths"),
        ("dm2", "Claustrophobopolis"),
        ("dm3", "The Abandoned Base"),
        ("dm4", "The Bad Place"),
        ("dm5", "The Cistern"),
        ("dm6", "The Dark Zone"),
    ]),
    ("Scourge of Armagon", [
        ("start", "Command HQ"),
    ]),
    ("Fortress of the Dead", [
        ("hip1m1", "The Pumping Station"),
        ("hip1m2", "Storage Facility"),
        ("hip1m5", "Military Complex (Secret Level)"),
        ("hip1m3", "The Lost Mine"),
        ("hip1m4", "Research Facility"),
    ]),
    ("Dominion of Darkness", [
        ("hip2m1", "Ancient Realms"),
        ("hip2m6", "The Gremlin's Domain (Secret Level)"),
        ("hip2m2", "The Black Cathedral"),
        ("hip2m3", "The Catacombs"),
        ("hip2m4", "The Crypt"),
        ("hip2m5", "Mortum's Keep"),
    ]),
    ("The Rift", [
        ("hip3m1", "Tur Torment"),
        ("hip3m2", "Pandemonium"),
        ("hip3m3", "Limbo"),
        ("hipdm1", "The Edge of Oblivion (Secret Level)"),
        ("hip3m4", "The Gauntlet"),
        ("hipend", "Armagon's Lair"),
    ]),
    ("Introduction (Dissolution of Eternity)", [
        ("start", "Split Decision"),
    ]),
    ("Hells Fortress", [
        ("r1m1", "Deviant's Domain"),
        ("r1m2", "Dread Portal"),
        ("r1m3", "Judgment Call"),
        ("r1m4", "Cave of Death"),
        ("r1m5", "Towers of Wrath"),
        ("r1m6", "Temple of Pain"),
        ("r1m7", "Tomb of the Overlord"),
    ]),
    ("The Corridors of Time", [
        ("r2m1", "Tempus Fugit"),
        ("r2m2", "Elemental Fury I"),
        ("r2m3", "Elemental Fury II"),
        ("r2m4", "Curse of Osiris"),
        ("r2m5", "Wizard's Keep"),
        ("r2m6", "Blood Sacrifice"),
        ("r2m7", "Last Bastion"),
        ("r2m8", "Source of Evil"),
    ]),
]


def find_map_location(code):
    """Procura um código de mapa (ex: 'dm3') em QUAKE_EPISODES e devolve
    (índice_do_episódio, texto_exibido_no_combo) ou None se não achar."""
    for idx, (_, maps) in enumerate(QUAKE_EPISODES):
        for c, name in maps:
            if c == code:
                return idx, "{}  [{}]".format(name, c)
    return None


# ----------------------------------------------------------------------
# Utilidades de configuração (settings do painel)
# ----------------------------------------------------------------------

def load_app_settings():
    defaults = build_default_settings()
    if os.path.exists(APP_SETTINGS_FILE):
        try:
            with open(APP_SETTINGS_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
            merged = dict(defaults)
            merged.update(data)

            if merged.get("server_dir_custom"):
                # o usuário escolheu essa pasta/executável na mão (aba
                # Configurações, botão Salvar) — respeita a escolha, a não
                # ser que a pasta salva tenha deixado de existir
                if not merged.get("server_dir") or not os.path.isdir(merged["server_dir"]):
                    merged["server_dir"] = defaults["server_dir"]
                    merged["executable"] = defaults["executable"]
                    merged["server_dir_custom"] = False
            else:
                # nunca foi customizada pelo usuário: sempre usa a pasta de
                # onde o programa está rodando agora, mesmo que o json já
                # exista com um valor antigo (ex: launcher movido/reinstalado
                # em outra pasta)
                merged["server_dir"] = defaults["server_dir"]
                merged["executable"] = defaults["executable"]

            return merged
        except Exception:
            pass
    return defaults


def save_app_settings(settings):
    try:
        with open(APP_SETTINGS_FILE, "w", encoding="utf-8") as f:
            json.dump(settings, f, indent=2, ensure_ascii=False)
    except Exception as e:
        print(T("console_save_settings_fail"), e)


# ----------------------------------------------------------------------
# Leitura/escrita do server.cfg
# ----------------------------------------------------------------------

CFG_FIELDS = [
    "hostname", "deathmatch", "teamplay", "maxclients",
    "maxspectators", "fraglimit", "timelimit",
    "password", "rcon_password",
]


# Comentários que o próprio painel escreve no server.cfg (em qualquer um
# dos 2 idiomas). Precisam ser ignorados ao reler o arquivo, senão viram
# "linhas extras do usuário" e se multiplicam a cada vez que o servidor
# é iniciado.
_AUTO_GENERATED_COMMENTS = {
    entry["pt_BR"] for entry in (STRINGS["cfg_comment_extra"], STRINGS["cfg_comment_startmap"])
} | {
    entry["en"] for entry in (STRINGS["cfg_comment_extra"], STRINGS["cfg_comment_startmap"])
}


def parse_cfg(path):
    """Lê um server.cfg existente e devolve um dict com os valores
    encontrados (chave -> valor sem aspas) e a lista de linhas 'extras'
    (tudo que o painel não reconhece, para não perder nada)."""
    values = {}
    extra_lines = []
    if not os.path.exists(path):
        return values, extra_lines

    known_prefixes = tuple(CFG_FIELDS) + ("samelevel", "noexit", "map", "allow_download")
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        for raw_line in f:
            line = raw_line.rstrip("\n")
            stripped = line.strip()
            if not stripped:
                continue
            if stripped in _AUTO_GENERATED_COMMENTS:
                continue
            m_info = re.match(r'^serverinfo\s+(\w+)\s+"?([^"]*)"?\s*$', stripped)
            if m_info:
                values["serverinfo_" + m_info.group(1)] = m_info.group(2)
                continue
            m = re.match(r'^(\w+)\s+"?([^"]*)"?\s*$', stripped)
            if m and m.group(1) in known_prefixes:
                key, val = m.group(1), m.group(2)
                values[key] = val
            else:
                extra_lines.append(line)
    return values, extra_lines


def build_cfg_text(values, extra_text, start_map):
    """Monta o texto final do server.cfg no mesmo estilo do arquivo original."""
    lines = []

    def add_quoted(key, val):
        lines.append('{} "{}"'.format(key, val))

    def add_plain(key, val):
        lines.append("{} {}".format(key, val))

    add_quoted("hostname", values.get("hostname", "Quake Server"))
    add_plain("deathmatch", values.get("deathmatch", "1"))
    add_plain("teamplay", values.get("teamplay", "0"))
    add_plain("maxclients", values.get("maxclients", "8"))
    add_plain("maxspectators", values.get("maxspectators", "4"))
    add_plain("fraglimit", values.get("fraglimit", "0"))
    add_plain("timelimit", values.get("timelimit", "20"))

    if values.get("samelevel"):
        add_plain("samelevel", values["samelevel"])
    if values.get("noexit"):
        add_plain("noexit", values["noexit"])
    if values.get("password"):
        add_quoted("password", values["password"])
    if values.get("rcon_password"):
        add_quoted("rcon_password", values["rcon_password"])
    if values.get("allow_download"):
        add_plain("allow_download", values["allow_download"])
    if values.get("serverinfo_admin"):
        lines.append('serverinfo admin "{}"'.format(values["serverinfo_admin"]))
    if values.get("serverinfo_url"):
        lines.append('serverinfo url "{}"'.format(values["serverinfo_url"]))

    extra_text = (extra_text or "").strip()
    if extra_text:
        lines.append("")
        lines.append(T("cfg_comment_extra"))
        for l in extra_text.splitlines():
            if l.strip():
                lines.append(l.rstrip())

    if start_map:
        lines.append("")
        lines.append(T("cfg_comment_startmap"))
        add_plain("map", start_map)

    return "\n".join(lines) + "\n"


# ----------------------------------------------------------------------
# Consulta de status via protocolo QuakeWorld (UDP "status")
# ----------------------------------------------------------------------

def query_qw_status(host, port, timeout=1.5):
    """Envia um pacote 'status' fora-de-banda para o servidor e devolve
    (serverinfo_dict, lista_de_nomes_de_jogadores).
    Levanta exceção se não houver resposta (servidor offline)."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(timeout)
    try:
        packet = b"\xff\xff\xff\xffstatus\n"
        sock.sendto(packet, (host, int(port)))
        data, _ = sock.recvfrom(8192)
    finally:
        sock.close()

    text = data[4:].decode("latin-1", errors="replace")
    # a primeira linha (depois do byte de comando) costuma ser o serverinfo,
    # no formato \chave\valor\chave\valor...
    lines = text.split("\n")
    if lines and lines[0].startswith("n"):
        lines[0] = lines[0][1:]

    serverinfo = {}
    if lines:
        parts = lines[0].split("\\")
        it = iter(parts[1:] if parts and parts[0] == "" else parts)
        for k, v in zip(it, it):
            serverinfo[k] = v

    players = []
    for line in lines[1:]:
        line = line.strip()
        if not line:
            continue
        quoted = re.findall(r'"([^"]*)"', line)
        if quoted:
            players.append(quoted[0])

    return serverinfo, players


def rcon_send(host, port, password, command, timeout=1.5):
    """Envia um comando de administração remota (rcon) e devolve o texto
    de resposta do servidor. Levanta exceção se não houver resposta."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(timeout)
    try:
        payload = 'rcon "{}" {}\n'.format(password, command).encode("latin-1", errors="replace")
        packet = b"\xff\xff\xff\xff" + payload
        sock.sendto(packet, (host, int(port)))
        data, _ = sock.recvfrom(8192)
    finally:
        sock.close()

    text = data[4:].decode("latin-1", errors="replace")
    # a resposta vem como um "print" fora-de-banda; o 1º byte costuma ser
    # um caractere de controle (ex: 'l' / 'n') que não faz parte da mensagem
    if text and (ord(text[0]) < 32 or not text[0].isprintable()):
        text = text[1:]
    return text.strip()


def parse_rcon_status(text):
    """Faz o parsing da saída de 'rcon status' desse build específico do
    QWSV (2.30, 17/ago/1998), que imprime cada cliente em DUAS linhas:

        <nome>            <userid> <frags>
          <endereço:porta> <rate> <ping> <drop>

    Devolve uma lista de dicts: {"name", "userid", "address", "frags"}.
    O parsing é tolerante a variações de espaçamento."""
    lines = text.splitlines()
    ip_re = re.compile(r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(?::\d+)?")
    players = []
    for i, line in enumerate(lines):
        m = ip_re.search(line)
        if not m:
            continue
        address = m.group(0).split(":")[0]

        prev = lines[i - 1].strip() if i > 0 else ""
        if not prev or set(prev) <= set("- "):
            continue
        low = prev.lower()
        if low.startswith("name") or low.startswith("frags") or low.startswith("----"):
            continue

        tokens = prev.split()
        numeric_tail = []
        idx = len(tokens) - 1
        while idx >= 0 and len(numeric_tail) < 2 and re.match(r"^-?\d+$", tokens[idx]):
            numeric_tail.insert(0, tokens[idx])
            idx -= 1
        if not numeric_tail:
            continue

        name = " ".join(tokens[: idx + 1]).strip() or T("no_name")
        userid = numeric_tail[0]
        frags = numeric_tail[1] if len(numeric_tail) > 1 else ""
        players.append({"name": name, "userid": userid, "address": address, "frags": frags})
    return players


# ----------------------------------------------------------------------
# Painel principal
# ----------------------------------------------------------------------

class QuakePanel(tk.Tk):
    def __init__(self, mode="full", launch_map=None, launch_port=None):
        super().__init__()
        # mode: "full"  -> tela padrão de sempre (parâmetro "Debug" ou nenhum)
        #       "light" -> tela reduzida, só com a lista de jogadores,
        #                  e inicia o servidor sozinho (parâmetro "Phobos")
        # launch_map/launch_port: vieram do DOS Game Launcher na linha de
        # comando ("+map <mapa> -port <porta>") — sobrescrevem, só nesta
        # execução, o mapa/porta que estavam salvos
        self.mode = mode

        # escondida até tudo estar montado no modo certo — evita o "flash"
        # da tela Padrão aparecendo por uma fração de segundo antes de
        # encolher pro modo light
        self.withdraw()

        self.title("DOS GAME LAUNCHER - QuakeWorld Server 2.30")
        self.geometry("880x560")
        self.minsize(820, 520)
        self._apply_window_icon()

        self.settings = load_app_settings()
        if launch_map:
            self.settings["last_map"] = launch_map
        if launch_port:
            self.settings["port"] = launch_port
        self.proc = None
        self.log_path = None
        self.players_info = []
        self._preserved_extra_lines = []

        self._build_ui()
        self._load_cfg_into_fields()
        self._apply_view_mode(self.mode)
        self._poll_status()
        self.protocol("WM_DELETE_WINDOW", self._on_close)

        # só agora, com o layout/tamanho já certos, a janela aparece
        self.deiconify()

        if self.mode == "light":
            # dá um tempinho pra janela desenhar antes de disparar o
            # servidor, senão o usuário nem vê a tela subindo
            self.after(300, self._auto_start_server)

    def _apply_window_icon(self):
        """O --icon do PyInstaller só troca o ícone do arquivo .exe (o que
        aparece no Explorer) — o ícone da JANELA/barra de tarefas enquanto
        o programa roda é outra coisa, controlada aqui. Sem isso, o
        Tkinter mostra a "peninha" padrão dele.

        Procura um .ico com o mesmo nome do executável (ex: qw_panel.ico
        do lado de qw_panel.exe) na pasta do programa. Se não achar, ou
        se não for Windows, simplesmente ignora e segue com o padrão."""
        if not IS_WINDOWS:
            return
        app_dir = get_app_dir()
        exe_name = os.path.splitext(os.path.basename(sys.executable if getattr(sys, "frozen", False)
                                                       else os.path.abspath(__file__)))[0]
        candidates = [
            os.path.join(app_dir, exe_name + ".ico"),
            os.path.join(app_dir, "qw_panel.ico"),
            os.path.join(app_dir, "icon.ico"),
        ]
        for ico_path in candidates:
            if os.path.isfile(ico_path):
                try:
                    self.iconbitmap(ico_path)
                except Exception:
                    pass
                return

    def _on_close(self):
        # rede de segurança: garante que o último mapa fica salvo E que o
        # qwsv.exe não fica rodando sozinho (órfão) quando a janela é
        # fechada no X, sem passar pelo botão Parar
        self._persist_last_map()
        self._stop_server_process(quiet=True)
        self.destroy()

    # ---------------- UI ----------------

    def _build_ui(self):
        main = ttk.Frame(self, padding=10)
        main.pack(fill="both", expand=True)
        self.main_frame = main

        main.columnconfigure(0, weight=3)
        main.columnconfigure(1, weight=1)
        main.rowconfigure(1, weight=1)

        # ---- Cabeçalho: status ----
        header = ttk.Frame(main)
        header.grid(row=0, column=0, columnspan=2, sticky="ew", pady=(0, 10))
        header.columnconfigure(1, weight=1)
        self.header_frame = header

        ttk.Label(header, text="QuakeWorld Server 2.30",
                  font=("TkDefaultFont", 14, "bold")).grid(row=0, column=0, sticky="w")

        self.status_var = tk.StringVar(value="OFFLINE")
        self.status_label = tk.Label(header, textvariable=self.status_var,
                                      font=("TkDefaultFont", 12, "bold"),
                                      fg="white", bg="#b03a2e", padx=12, pady=4)
        self.status_label.grid(row=0, column=2, sticky="e")

        # ---- Coluna esquerda: configurações + mapa + botões ----
        left = ttk.Notebook(main)
        left.grid(row=1, column=0, sticky="nsew", padx=(0, 10))
        self.left_notebook_frame = left

        cfg_tab = ttk.Frame(left, padding=10)
        admin_tab = ttk.Frame(left, padding=10)
        conn_tab = ttk.Frame(left, padding=10)
        left.add(cfg_tab, text=T("tab_start"))
        left.add(admin_tab, text=T("tab_running"))
        left.add(conn_tab, text=T("tab_settings"))

        self.tabs_notebook = left
        self.inicio_tab_index = 0
        self.admin_tab_index = 1
        self.config_tab_index = 2

        self._build_cfg_tab(cfg_tab)
        self._build_admin_tab(admin_tab)
        self._build_conn_tab(conn_tab)

        # botões de ação (fora das abas, sempre visíveis)
        actions = ttk.Frame(main)
        actions.grid(row=2, column=0, sticky="ew", pady=(10, 0))
        self.actions_frame = actions

        self.start_btn = ttk.Button(actions, text=T("btn_start"),
                                     command=self.on_start)
        self.start_btn.pack(side="left", padx=(0, 6))
        self.stop_btn = ttk.Button(actions, text=T("btn_stop"),
                                    command=self.on_stop, state="disabled")
        self.stop_btn.pack(side="left", padx=6)
        ttk.Button(actions, text=T("btn_view_log"), command=self.on_view_log).pack(side="left", padx=6)

        # ---- Coluna direita: jogadores online ----
        right = ttk.Labelframe(main, text=T("online_players"), padding=10)
        right.grid(row=1, column=1, rowspan=2, sticky="nsew")
        right.rowconfigure(2, weight=1)
        right.columnconfigure(0, weight=1)
        self.right_frame = right

        # indicador ONLINE/OFFLINE — mesmas cores do cabeçalho do modo
        # Padrão, só que numa versão mais compacta (fonte e respiro
        # menores), já que aqui ele fica sozinho em cima da lista
        self.light_status_label = tk.Label(right, textvariable=self.status_var,
                                            font=("TkDefaultFont", 9, "bold"),
                                            fg="white", bg="#b03a2e", padx=8, pady=2)
        self.light_status_label.grid(row=0, column=0, sticky="w", pady=(0, 8))
        self.light_status_label.grid_remove()  # só é mostrado em _apply_view_mode("light")

        self.players_count_var = tk.StringVar(value=T("players_count", 0))
        ttk.Label(right, textvariable=self.players_count_var).grid(row=1, column=0, sticky="w")

        self.players_list = tk.Listbox(right, height=12, width=18)
        self.players_list.grid(row=2, column=0, sticky="nsew", pady=(6, 6))
        self.players_list.bind("<Button-3>", self._on_player_right_click)

        ttk.Button(right, text=T("btn_refresh"),
                   command=self.refresh_players).grid(row=3, column=0, sticky="ew")

        # botão alternador Padrão <-> Light — sempre visível, nos dois
        # modos, no mesmo lugar (linha 4 do painel de jogadores)
        self.mode_toggle_btn = ttk.Button(right, text=T("btn_standard_mode"),
                                           command=self._toggle_view_mode)
        self.mode_toggle_btn.grid(row=4, column=0, sticky="ew", pady=(6, 0))


    # ---------------- Modo de exibição (Padrão x Light/Phobos) ----------------

    def _toggle_view_mode(self):
        self._apply_view_mode("full" if self.mode == "light" else "light")

    def _apply_view_mode(self, mode):
        """Alterna entre a tela cheia de sempre ('full') e a versão
        reduzida ('light') usada quando o painel é aberto com o parâmetro
        'Phobos' pelo DOS Game Launcher — só a lista de jogadores e um
        botão pra alternar entre os dois modos."""
        self.mode = mode
        light = (mode == "light")

        if light:
            self.header_frame.grid_remove()
            self.left_notebook_frame.grid_remove()
            self.actions_frame.grid_remove()

            self.main_frame.columnconfigure(0, weight=0)
            self.main_frame.columnconfigure(1, weight=1)
            self.right_frame.grid_configure(row=0, column=0, columnspan=2, rowspan=1)

            self.light_status_label.grid()
            self.mode_toggle_btn.config(text=T("btn_standard_mode"))

            self.title("QUAKE SERVER 2.30")
            # o minsize herdado do modo Padrão (mais embaixo) travava a
            # janela em 820x520 mesmo pedindo uma geometria menor — precisa
            # ser solto ANTES de calcular/pedir o tamanho pequeno
            self.minsize(1, 1)
            self.resizable(True, True)

            # calcula a altura certa medindo o que o conteúdo realmente
            # precisa (bolinha de status + lista + botões); a largura é o
            # dobro disso, senão o título "QUAKE SERVER 2.30" não cabe
            # inteiro na barra de título
            self.update_idletasks()
            width = (self.main_frame.winfo_reqwidth() + 16) * 2
            height = self.main_frame.winfo_reqheight() + 16
            self.geometry("{}x{}".format(width, height))
        else:
            self.header_frame.grid()
            self.left_notebook_frame.grid()
            self.actions_frame.grid()

            self.main_frame.columnconfigure(0, weight=3)
            self.main_frame.columnconfigure(1, weight=1)
            self.right_frame.grid_configure(row=1, column=1, columnspan=1, rowspan=2)

            self.light_status_label.grid_remove()
            self.mode_toggle_btn.config(text=T("btn_light_mode"))

            self.resizable(True, True)
            self.title("DOS GAME LAUNCHER - QuakeWorld Server 2.30")
            self.geometry("880x560")
            self.minsize(820, 520)

    def _auto_start_server(self):
        """Usado só no modo 'light' (parâmetro Phobos): sobe o servidor
        sozinho ao abrir, sem precisar clicar em Iniciar. Se já tiver um
        servidor rodando nessa porta, não faz nada (evita erro de porta
        em uso ao reabrir o painel com o servidor já de pé)."""
        if self._find_pid() is not None:
            return
        self.on_start()

    def _build_cfg_tab(self, parent):
        parent.columnconfigure(1, weight=1)
        row = 0

        self.hostname_var = tk.StringVar()
        self.teamplay_var = tk.StringVar(value="0")
        self.maxclients_var = tk.StringVar(value="8")
        self.maxspectators_var = tk.StringVar(value="4")
        self.fraglimit_var = tk.StringVar(value="0")
        self.timelimit_var = tk.StringVar(value="20")
        self.password_var = tk.StringVar()
        self.rcon_password_var = tk.StringVar()
        self.samelevel_var = tk.BooleanVar(value=False)
        self.noexit_var = tk.BooleanVar(value=False)
        self.admin_email_var = tk.StringVar()
        self.admin_url_var = tk.StringVar()
        self.allow_download_var = tk.BooleanVar(value=True)

        # widgets que só fazem sentido mudar com o servidor OFFLINE (valores
        # que só têm efeito no próximo início, via server.cfg)
        self.inicio_restart_widgets = []

        def add_row(label, widget, restart_only=True):
            nonlocal row
            ttk.Label(parent, text=label).grid(row=row, column=0, sticky="w", pady=3)
            widget.grid(row=row, column=1, sticky="ew", pady=3)
            if restart_only:
                self.inicio_restart_widgets.append(widget)
            row += 1

        add_row(T("label_hostname"), ttk.Entry(parent, textvariable=self.hostname_var))
        add_row(T("label_teamplay"), ttk.Combobox(parent, textvariable=self.teamplay_var,
                                                values=["0", "1", "2", "3"], state="readonly"))
        add_row(T("label_maxclients"), ttk.Spinbox(parent, from_=1, to=32, textvariable=self.maxclients_var))
        add_row(T("label_maxspectators"), ttk.Spinbox(parent, from_=0, to=32, textvariable=self.maxspectators_var))
        add_row(T("label_fraglimit"), ttk.Spinbox(parent, from_=0, to=100, textvariable=self.fraglimit_var),
                restart_only=False)
        add_row(T("label_timelimit"), ttk.Spinbox(parent, from_=0, to=120, textvariable=self.timelimit_var),
                restart_only=False)
        add_row(T("label_password"), ttk.Entry(parent, textvariable=self.password_var, show="*"))
        add_row(T("label_rcon_password"), ttk.Entry(parent, textvariable=self.rcon_password_var, show="*"))
        add_row(T("label_admin_email"), ttk.Entry(parent, textvariable=self.admin_email_var), restart_only=False)
        add_row(T("label_admin_url"), ttk.Entry(parent, textvariable=self.admin_url_var), restart_only=False)

        self.allow_download_check = ttk.Checkbutton(
            parent, text=T("check_allow_download"), variable=self.allow_download_var)
        self.allow_download_check.grid(row=row, column=0, columnspan=2, sticky="w", pady=3)
        row += 1

        self.samelevel_check = ttk.Checkbutton(
            parent, text=T("check_samelevel"), variable=self.samelevel_var)
        self.samelevel_check.grid(row=row, column=0, columnspan=2, sticky="w", pady=3)
        self.inicio_restart_widgets.append(self.samelevel_check)
        row += 1

        self.noexit_check = ttk.Checkbutton(
            parent, text=T("check_noexit"), variable=self.noexit_var)
        self.noexit_check.grid(row=row, column=0, columnspan=2, sticky="w", pady=3)
        self.inicio_restart_widgets.append(self.noexit_check)
        row += 1

    def _set_inicio_restart_fields_enabled(self, enabled):
        """Habilita/desabilita, na aba Início, só os campos que precisam do
        servidor reiniciado para valer (os demais — Admin/URL/permitir
        download — podem ser aplicados com o servidor rodando, na aba
        'Servidor em Execução')."""
        for w in self.inicio_restart_widgets:
            try:
                if isinstance(w, ttk.Combobox):
                    w.config(state="readonly" if enabled else "disabled")
                else:
                    w.config(state="normal" if enabled else "disabled")
            except Exception:
                pass

    def _build_conn_tab(self, parent):
        parent.columnconfigure(1, weight=1)

        self.server_dir_var = tk.StringVar(value=self.settings["server_dir"])
        self.executable_var = tk.StringVar(value=self.settings["executable"])
        self.port_var = tk.StringVar(value=self.settings["port"])
        self.cfg_relpath_var = tk.StringVar(value=self.settings["cfg_relative_path"])

        ttk.Label(parent, text=T("label_server_dir")).grid(row=0, column=0, sticky="w", pady=4)
        ttk.Entry(parent, textvariable=self.server_dir_var).grid(row=0, column=1, sticky="ew", pady=4)
        ttk.Button(parent, text=T("btn_browse"), command=self._browse_server_dir).grid(row=0, column=2, padx=(6, 0))

        ttk.Label(parent, text=T("label_executable")).grid(row=1, column=0, sticky="w", pady=4)
        ttk.Entry(parent, textvariable=self.executable_var).grid(row=1, column=1, sticky="ew", pady=4)
        ttk.Button(parent, text=T("btn_browse"), command=self._browse_executable).grid(row=1, column=2, padx=(6, 0))

        ttk.Label(parent, text=T("label_port")).grid(row=2, column=0, sticky="w", pady=4)
        ttk.Entry(parent, textvariable=self.port_var).grid(row=2, column=1, sticky="ew", pady=4)

        ttk.Label(parent, text=T("label_cfg_path")).grid(
            row=3, column=0, sticky="w", pady=4)
        ttk.Entry(parent, textvariable=self.cfg_relpath_var).grid(row=3, column=1, sticky="ew", pady=4)
        ttk.Button(parent, text=T("btn_browse"), command=self._browse_cfg_path).grid(row=3, column=2, padx=(6, 0))

        ttk.Button(parent, text=T("btn_save"),
                   command=self._save_conn_settings).grid(row=4, column=0, columnspan=2, pady=10)

        self.files_status_var = tk.StringVar(value="")
        self.files_status_label = ttk.Label(parent, textvariable=self.files_status_var)
        self.files_status_label.grid(row=5, column=0, columnspan=3, sticky="w")
        self._refresh_files_status()

    def _browse_server_dir(self):
        path = filedialog.askdirectory(initialdir=self.server_dir_var.get() or os.path.expanduser("~"))
        if path:
            self.server_dir_var.set(path)
            self._refresh_files_status()

    def _browse_executable(self):
        initial = self.server_dir_var.get() or os.path.expanduser("~")
        if IS_WINDOWS:
            filetypes = [(T("filetype_executable"), "*.exe"), (T("filetype_all_files"), "*.*")]
        else:
            filetypes = [(T("filetype_all_files"), "*")]
        path = filedialog.askopenfilename(initialdir=initial, filetypes=filetypes)
        if not path:
            return
        try:
            rel = os.path.relpath(path, self.server_dir_var.get())
        except Exception:
            rel = path
        if rel.startswith(".."):
            self.executable_var.set(path)
        else:
            if not IS_WINDOWS and not rel.startswith("."):
                rel = "./" + rel
            self.executable_var.set(rel)

    def _browse_cfg_path(self):
        initial = self.server_dir_var.get() or os.path.expanduser("~")
        filetypes = [(T("filetype_cfg"), "*.cfg"), (T("filetype_all_files"), "*.*" if IS_WINDOWS else "*")]
        path = filedialog.askopenfilename(initialdir=initial, filetypes=filetypes)
        if not path:
            return
        try:
            rel = os.path.relpath(path, self.server_dir_var.get())
        except Exception:
            rel = path
        self.cfg_relpath_var.set(path if rel.startswith("..") else rel)

    def _refresh_files_status(self):
        ok, msg = check_server_files(self.server_dir_var.get())
        if ok:
            self.files_status_var.set("id1: OK")
            self.files_status_label.config(foreground="#2e7d32")
        else:
            self.files_status_var.set("id1: " + msg)
            self.files_status_label.config(foreground="#b03a2e")
        return ok

    # ---------------- lógica ----------------

    def _wire_map_combos(self, episode_combo, map_combo, mapping_attr_name, initial_code=None):
        """Liga um par (combo de episódio, combo de mapa): ao trocar o
        episódio, repopula o combo de mapa. `mapping_attr_name` é o nome
        do atributo (em self) onde fica o dict {texto exibido: código do
        mapa}. Se `initial_code` for informado (ex: 'dm3'), o par já abre
        selecionando esse mapa em vez do primeiro da lista."""
        setattr(self, mapping_attr_name, {})

        def populate(idx):
            _, maps = QUAKE_EPISODES[idx]
            mapping = {}
            display_values = []
            for code, name in maps:
                display = "{}  [{}]".format(name, code)
                display_values.append(display)
                mapping[display] = code
            setattr(self, mapping_attr_name, mapping)
            map_combo["values"] = display_values
            return display_values

        def on_change(event=None):
            idx = episode_combo.current()
            if idx < 0:
                return
            display_values = populate(idx)
            if display_values:
                map_combo.current(0)

        episode_combo.bind("<<ComboboxSelected>>", on_change)

        init_episode_idx, init_display = 0, None
        if initial_code:
            loc = find_map_location(initial_code)
            if loc:
                init_episode_idx, init_display = loc

        episode_combo.current(init_episode_idx)
        display_values = populate(init_episode_idx)
        if init_display and init_display in display_values:
            map_combo.set(init_display)
        elif display_values:
            map_combo.current(0)

    def _build_admin_tab(self, parent):
        parent.columnconfigure(1, weight=1)
        self.live_action_widgets = []

        # ---- serverinfo / allow_download ----
        info_box = ttk.Labelframe(parent, text=T("box_server_startup_info"), padding=8)
        info_box.grid(row=1, column=0, columnspan=2, sticky="ew", pady=(0, 10))
        info_box.columnconfigure(0, weight=1)
        apply_info_btn = ttk.Button(info_box, text=T("btn_apply"), command=self.on_apply_serverinfo_live)
        apply_info_btn.grid(row=0, column=0, sticky="w")
        self.live_action_widgets.append(apply_info_btn)

        # ---- changelevel ----
        map_box = ttk.Labelframe(parent, text=T("box_change_map"), padding=8)
        map_box.grid(row=2, column=0, columnspan=2, sticky="ew", pady=(0, 10))
        map_box.columnconfigure(1, weight=1)

        self.live_episode_var = tk.StringVar()
        self.live_map_var = tk.StringVar()
        episode_names = [e[0] for e in QUAKE_EPISODES]

        ttk.Label(map_box, text=T("label_episode")).grid(row=0, column=0, sticky="w", pady=3)
        self.live_episode_combo = ttk.Combobox(map_box, textvariable=self.live_episode_var,
                                                values=episode_names, state="readonly")
        self.live_episode_combo.grid(row=0, column=1, sticky="ew", pady=3)

        ttk.Label(map_box, text=T("label_map")).grid(row=1, column=0, sticky="w", pady=3)
        self.live_map_combo = ttk.Combobox(map_box, textvariable=self.live_map_var, state="readonly")
        self.live_map_combo.grid(row=1, column=1, sticky="ew", pady=3)

        self._wire_map_combos(self.live_episode_combo, self.live_map_combo,
                               "live_map_display_to_code",
                               initial_code=self.settings.get("last_map", "start"))

        changelevel_btn = ttk.Button(map_box, text=T("btn_change_map"), command=self.on_changelevel_live)
        changelevel_btn.grid(row=2, column=0, columnspan=2, sticky="w", pady=(6, 0))
        self.live_action_widgets.append(changelevel_btn)

        # ---- say ----
        say_box = ttk.Labelframe(parent, text=T("box_message_players"), padding=8)
        say_box.grid(row=3, column=0, columnspan=2, sticky="ew", pady=(0, 10))
        say_box.columnconfigure(0, weight=1)

        history_frame = ttk.Frame(say_box)
        history_frame.grid(row=0, column=0, columnspan=2, sticky="ew", pady=(0, 6))
        history_frame.columnconfigure(0, weight=1)

        self.say_history_list = tk.Listbox(history_frame, height=5)
        self.say_history_list.grid(row=0, column=0, sticky="ew")
        history_scroll = ttk.Scrollbar(history_frame, orient="vertical", command=self.say_history_list.yview)
        history_scroll.grid(row=0, column=1, sticky="ns")
        self.say_history_list.config(yscrollcommand=history_scroll.set)

        self.say_var = tk.StringVar()
        say_entry = ttk.Entry(say_box, textvariable=self.say_var)
        say_entry.grid(row=1, column=0, sticky="ew")
        say_entry.bind("<Return>", lambda e: self.on_say_send())
        say_send_btn = ttk.Button(say_box, text=T("btn_send"), command=self.on_say_send)
        say_send_btn.grid(row=1, column=1, padx=(6, 0))
        self.live_action_widgets.append(say_entry)
        self.live_action_widgets.append(say_send_btn)

    def _set_live_actions_enabled(self, enabled):
        """Habilita/desabilita os botões da aba 'Servidor em Execução' que
        dependem de RCON — não faz sentido eles ficarem clicáveis com o
        servidor OFFLINE."""
        state = "normal" if enabled else "disabled"
        for w in self.live_action_widgets:
            try:
                w.config(state=state)
            except Exception:
                pass

    def _save_conn_settings(self):
        server_dir = self.server_dir_var.get().strip()
        executable = self.executable_var.get().strip()
        port = self.port_var.get().strip()
        cfg_relpath = self.cfg_relpath_var.get().strip()

        faltando = []
        if not server_dir:
            faltando.append(T("label_server_dir"))
        if not executable:
            faltando.append(T("label_executable"))
        if not port:
            faltando.append(T("label_port"))
        if not cfg_relpath:
            faltando.append(T("label_cfg_path"))
        if faltando:
            messagebox.showerror(
                T("panel_title"), T("err_missing_fields") + "\n- ".join(faltando))
            return

        self.settings["server_dir"] = server_dir
        self.settings["executable"] = executable
        self.settings["port"] = port
        self.settings["cfg_relative_path"] = cfg_relpath
        # a partir daqui a pasta/executável passam a ser "customizados": o
        # painel não vai mais sobrescrever com a pasta atual do programa
        # em execuções futuras, respeitando o que foi salvo aqui na mão
        self.settings["server_dir_custom"] = True
        save_app_settings(self.settings)
        self._refresh_files_status()
        messagebox.showinfo(T("panel_title"), T("info_updated"))

    def _cfg_path(self):
        return os.path.join(self.server_dir_var.get(), self.cfg_relpath_var.get())

    def _load_cfg_into_fields(self):
        values, extra_lines = parse_cfg(self._cfg_path())
        if values.get("hostname"):
            self.hostname_var.set(values["hostname"])
        else:
            self.hostname_var.set("QuakeWorld Server")
        self.teamplay_var.set(values.get("teamplay", "0"))
        self.maxclients_var.set(values.get("maxclients", "8"))
        self.maxspectators_var.set(values.get("maxspectators", "4"))
        self.fraglimit_var.set(values.get("fraglimit", "0"))
        self.timelimit_var.set(values.get("timelimit", "20"))
        self.password_var.set(values.get("password", ""))
        self.rcon_password_var.set(values.get("rcon_password", ""))
        self.samelevel_var.set(values.get("samelevel", "0") == "1")
        self.noexit_var.set(values.get("noexit", "0") == "1")
        self.admin_email_var.set(values.get("serverinfo_admin", ""))
        self.admin_url_var.set(values.get("serverinfo_url", ""))
        self.allow_download_var.set(values.get("allow_download", "1") != "0")

        self._preserved_extra_lines = extra_lines

    def _collect_cfg_values(self):
        return {
            "hostname": self.hostname_var.get().strip() or "QuakeWorld Server",
            "teamplay": self.teamplay_var.get().strip(),
            "maxclients": self.maxclients_var.get().strip(),
            "maxspectators": self.maxspectators_var.get().strip(),
            "fraglimit": self.fraglimit_var.get().strip(),
            "timelimit": self.timelimit_var.get().strip(),
            "password": self.password_var.get().strip(),
            "rcon_password": self.rcon_password_var.get().strip(),
            "samelevel": "1" if self.samelevel_var.get() else "",
            "noexit": "1" if self.noexit_var.get() else "",
            "allow_download": "1" if self.allow_download_var.get() else "0",
            "serverinfo_admin": self.admin_email_var.get().strip(),
            "serverinfo_url": self.admin_url_var.get().strip(),
        }

    def _save_cfg_file(self):
        """Grava o server.cfg no disco. Levanta exceção se algo der errado."""
        cfg_path = self._cfg_path()
        os.makedirs(os.path.dirname(cfg_path), exist_ok=True)

        # mapa inicial: "start" a menos que a última sessão tenha salvo outro
        map_code = self.settings.get("last_map", "start")

        text = build_cfg_text(
            self._collect_cfg_values(),
            "\n".join(self._preserved_extra_lines),
            map_code,
        )
        with open(cfg_path, "w", encoding="utf-8") as f:
            f.write(text)
        return cfg_path

    def on_start(self):
        if self._find_pid() is not None:
            messagebox.showwarning(T("panel_title"), T("err_port_unavailable"))
            return

        server_dir = self.server_dir_var.get()
        executable = self.executable_var.get()
        port = self.port_var.get()

        if not os.path.isdir(server_dir):
            messagebox.showerror(T("panel_title"), T("err_invalid_dir", server_dir))
            return

        files_ok, files_msg = check_server_files(server_dir)
        self._refresh_files_status()
        if not files_ok:
            messagebox.showerror(T("panel_title"), T("err_cannot_start", files_msg))
            return

        try:
            self._save_cfg_file()
        except Exception as e:
            messagebox.showerror(T("panel_title"), T("err_save_cfg", e))
            return

        self.log_path = os.path.join(server_dir, "qw_panel.log")
        try:
            log_file = open(self.log_path, "ab", buffering=0)
        except Exception as e:
            messagebox.showerror(T("panel_title"), T("err_open_log", e))
            return

        popen_kwargs = dict(
            cwd=server_dir,
            stdout=log_file,
            stderr=subprocess.STDOUT,
            stdin=subprocess.DEVNULL,
        )
        if IS_WINDOWS:
            popen_kwargs["creationflags"] = subprocess.CREATE_NO_WINDOW
        else:
            popen_kwargs["start_new_session"] = True

        try:
            self.proc = subprocess.Popen([executable, "-port", port], **popen_kwargs)
        except Exception as e:
            messagebox.showerror(T("panel_title"), T("err_start_server", e))
            return

        self.start_btn.config(state="disabled")
        self.stop_btn.config(state="normal")

    def _stop_server_process(self, quiet=False):
        """Mata o processo do servidor, se estiver rodando (seja o que
        este painel iniciou, seja um qwsv já rodando na porta configurada
        antes de o painel abrir). Devolve True se havia processo pra
        matar. `quiet=True` (usado ao fechar a janela no X) não mostra
        nenhuma messagebox, só tenta encerrar sem interromper o fechamento."""
        pid = None
        if self.proc and self.proc.poll() is None:
            pid = self.proc.pid
        else:
            pid = self._find_pid()

        if pid is None:
            if not quiet:
                messagebox.showinfo(T("panel_title"), T("info_no_server_running"))
            return False

        try:
            os.kill(pid, signal.SIGTERM)
        except Exception as e:
            if not quiet:
                messagebox.showerror(T("panel_title"), T("err_stop_process", pid, e))
        return True

    def on_stop(self):
        self._persist_last_map()
        self._stop_server_process(quiet=False)
        self.proc = None
        self.start_btn.config(state="normal")
        self.stop_btn.config(state="disabled")

    def on_view_log(self):
        path = self.log_path or os.path.join(self.server_dir_var.get(), "qw_panel.log")
        if not os.path.exists(path):
            messagebox.showinfo(T("panel_title"), T("info_no_log_yet"))
            return

        win = tk.Toplevel(self)
        win.title(T("log_window_title"))
        win.geometry("700x450")
        text = tk.Text(win, wrap="none")
        text.pack(fill="both", expand=True)
        try:
            with open(path, "r", encoding="utf-8", errors="replace") as f:
                text.insert("1.0", f.read())
        except Exception as e:
            text.insert("1.0", T("err_access_log", e))
        text.config(state="disabled")

    # ---------------- RCON / administração ao vivo ----------------

    def _rcon(self, command):
        """Dispara um comando de rcon no servidor local. Levanta exceção
        se a senha estiver vazia ou não houver resposta."""
        password = self.rcon_password_var.get().strip()
        if not password:
            raise ValueError(T("err_rcon_no_password"))
        port = self.port_var.get().strip()
        return rcon_send("127.0.0.1", port, password, command)

    def _persist_last_map(self, code=None):
        """Salva o mapa atual (episódio+mapa selecionados na aba 'Servidor
        em Execução') como 'último mapa', para o próximo início do servidor."""
        if code is None:
            code = self.live_map_display_to_code.get(self.live_map_var.get())
        if code:
            self.settings["last_map"] = code
            save_app_settings(self.settings)

    def on_apply_serverinfo_live(self):
        try:
            r1 = self._rcon('serverinfo admin "{}"'.format(self.admin_email_var.get().strip()))
            r2 = self._rcon('serverinfo url "{}"'.format(self.admin_url_var.get().strip()))
            r3 = self._rcon("allow_download {}".format("1" if self.allow_download_var.get() else "0"))
            r4 = self._rcon("fraglimit {}".format(self.fraglimit_var.get().strip()))
            r5 = self._rcon("timelimit {}".format(self.timelimit_var.get().strip()))
        except Exception as e:
            messagebox.showerror(T("panel_title"), T("err_update_server_info", e))
            return
        self._show_rcon_result(T("info_updated_success"), r1, r2, r3, r4, r5)

    def on_changelevel_live(self):
        display = self.live_map_var.get()
        code = self.live_map_display_to_code.get(display)
        if not code:
            messagebox.showwarning(T("panel_title"), T("warn_choose_map"))
            return
        try:
            # este build do QWSV (2.30, ago/1998) não tem "changelevel" —
            # o comando correto encontrado no executável é "map <fase>"
            resp = self._rcon("map {}".format(code))
        except Exception as e:
            messagebox.showerror(T("panel_title"), T("err_change_map", e))
            return
        self._persist_last_map(code)
        self._show_rcon_result(T("info_map_changed", display), resp)

    def on_say_send(self):
        msg = self.say_var.get().strip()
        if not msg:
            return
        try:
            self._rcon("say {}".format(msg))
        except Exception as e:
            messagebox.showerror(T("panel_title"), T("err_send_message", e))
            return
        self.say_history_list.insert("end", "[{}] {}".format(time.strftime("%H:%M:%S"), msg))
        self.say_history_list.see("end")
        self.say_var.set("")

    def _show_rcon_result(self, title, *responses):
        text = "\n".join(r for r in responses if r) or T("rcon_no_text")
        messagebox.showinfo(T("panel_title"), T("rcon_result_body", title, text))

    def _on_player_right_click(self, event):
        idx = self.players_list.nearest(event.y)
        if idx < 0 or idx >= len(self.players_info):
            return
        self.players_list.selection_clear(0, "end")
        self.players_list.selection_set(idx)
        info = self.players_info[idx]
        name = info["name"]

        menu = tk.Menu(self, tearoff=0)
        if info.get("userid"):
            menu.add_command(label=T("menu_kick", name, info["userid"]),
                              command=lambda: self._kick_player(info))
        else:
            menu.add_command(label=T("menu_kick_unavailable"), state="disabled")
        if info.get("address"):
            menu.add_command(label=T("menu_ban", name, info["address"]),
                              command=lambda: self._ban_player(info))
        else:
            menu.add_command(label=T("menu_ban_unavailable"), state="disabled")
        menu.tk_popup(event.x_root, event.y_root)

    def _kick_player(self, info):
        try:
            # nesse build o kick trabalha com o userid mostrado no status,
            # não com o nome do jogador
            resp = self._rcon("kick {}".format(info["userid"]))
        except Exception as e:
            messagebox.showerror(T("panel_title"), T("err_kick", e))
            return
        self._show_rcon_result(T("info_kick_sent", info["name"]), resp)
        self.refresh_players()

    def _ban_player(self, info):
        try:
            # não existe comando "ban" nesse build — banimento é por IP,
            # via addip (e writeip para persistir em listip.cfg)
            resp1 = self._rcon("addip {}".format(info["address"]))
            resp2 = self._rcon("writeip")
        except Exception as e:
            messagebox.showerror(T("panel_title"), T("err_ban", e))
            return
        self._show_rcon_result(T("info_ip_banned", info["address"]), resp1, resp2)
        self.refresh_players()

    def _find_pid(self):
        """Procura um processo qwsv já rodando nessa porta (por exemplo,
        iniciado manualmente antes de abrir o painel). Em caso de dúvida
        (ex: Windows sem psutil instalado), devolve None e o painel passa
        a confiar só no processo que ele mesmo iniciou."""
        port = self.port_var.get().strip()
        exe_name = os.path.basename(self.executable_var.get().strip()) or "qwsv"

        if IS_WINDOWS:
            return self._find_pid_windows(exe_name, port)

        try:
            out = subprocess.check_output(
                ["pgrep", "-f", "{}.*-port {}".format(re.escape(exe_name), port)],
                stderr=subprocess.DEVNULL,
            )
            pids = [int(p) for p in out.decode().split() if p.strip()]
            return pids[0] if pids else None
        except subprocess.CalledProcessError:
            return None
        except Exception:
            return None

    def _find_pid_windows(self, exe_name, port):
        try:
            import psutil
        except ImportError:
            return None
        try:
            for proc in psutil.process_iter(["pid", "name", "cmdline"]):
                try:
                    name = (proc.info.get("name") or "").lower()
                    cmdline = proc.info.get("cmdline") or []
                    cmdline_text = " ".join(cmdline).lower()
                    if exe_name.lower() not in name and exe_name.lower() not in cmdline_text:
                        continue
                    if port and port not in cmdline_text:
                        continue
                    return proc.info["pid"]
                except (psutil.NoSuchProcess, psutil.AccessDenied):
                    continue
        except Exception:
            return None
        return None

    def _is_running(self):
        if self.proc and self.proc.poll() is None:
            return True
        return self._find_pid() is not None

    def _set_other_tabs_locked(self, locked):
        # a aba "Configurações" só pode mudar com o servidor OFFLINE (ela
        # define diretório/executável/porta, que exigem reiniciar tudo).
        # A aba "Início" continua acessível — só os campos que exigem
        # reinício ficam desabilitados (ver _set_inicio_restart_fields_enabled).
        state = "disabled" if locked else "normal"
        self.tabs_notebook.tab(self.config_tab_index, state=state)

    def _poll_status(self):
        online = self._is_running()
        was_online = getattr(self, "_was_online", False)

        if online and not was_online:
            self._set_other_tabs_locked(True)
            self.tabs_notebook.select(self.admin_tab_index)
        elif not online and was_online:
            self._set_other_tabs_locked(False)
        self._was_online = online

        self._set_inicio_restart_fields_enabled(not online)
        self._set_live_actions_enabled(online)

        if online:
            self.status_var.set("ONLINE")
            self.status_label.config(bg="#2e7d32")
            self.light_status_label.config(bg="#2e7d32")
            self.start_btn.config(state="disabled")
            self.stop_btn.config(state="normal")
        else:
            files_ok = self._refresh_files_status()
            self.status_var.set("OFFLINE")
            self.status_label.config(bg="#b03a2e")
            self.light_status_label.config(bg="#b03a2e")
            self.start_btn.config(state="normal" if files_ok else "disabled")
            self.stop_btn.config(state="disabled")
            self.players_list.delete(0, "end")
            self.players_count_var.set(T("players_count", 0))

        if online:
            self.refresh_players()

        self.after(4000, self._poll_status)

    def refresh_players(self):
        port = self.port_var.get().strip()
        password = self.rcon_password_var.get().strip()

        players_info = []
        if password:
            try:
                resp = rcon_send("127.0.0.1", port, password, "status")
                players_info = parse_rcon_status(resp)
            except Exception:
                players_info = []

        if not players_info:
            # sem rcon_password (ou rcon falhou): mostra pelo menos os nomes
            # via consulta UDP simples, mas sem dá pra fazer kick/ban por
            # esse caminho (não temos userid/IP)
            try:
                _, names = query_qw_status("127.0.0.1", port)
            except Exception:
                return  # servidor pode estar subindo ainda; tenta de novo no próximo ciclo
            players_info = [{"name": n, "userid": None, "address": None} for n in names]

        self.players_info = players_info
        self.players_list.delete(0, "end")
        for info in players_info:
            label = info["name"]
            if info.get("userid"):
                label += "  (id {})".format(info["userid"])
            self.players_list.insert("end", label)
        self.players_count_var.set(T("players_count", len(players_info)))


def _get_launch_param():
    """Primeiro argumento de linha de comando, se houver (ex: 'Phobos'
    ou 'Debug' passado pelo DOS Game Launcher ou por um atalho de
    teste)."""
    if len(sys.argv) > 1 and sys.argv[1].strip():
        return sys.argv[1].strip()
    return None


def _get_launch_extra_args():
    """Lê '+map <mapa>' e '-port <porta>' do restante da linha de comando
    — é assim que o DOS Game Launcher chama o painel:

        qw_panel.exe Phobos +map dm2 -port 27500

    Devolve um dict com "map"/"port" (None se não vieram). Aceita os
    tokens em qualquer ordem/posição depois do primeiro argumento."""
    extra = {"map": None, "port": None}
    args = sys.argv[2:]
    i = 0
    while i < len(args):
        token = args[i].strip()
        if token.lower() == "+map" and i + 1 < len(args):
            extra["map"] = args[i + 1].strip()
            i += 2
            continue
        if token.lower() == "-port" and i + 1 < len(args):
            extra["port"] = args[i + 1].strip()
            i += 2
            continue
        i += 1
    return extra


if __name__ == "__main__":
    launch_param = _get_launch_param()
    param_lower = (launch_param or "").lower()

    # No Windows, o .exe gerado (PyInstaller) só pode ser aberto recebendo
    # um parâmetro conhecido — assim ele nunca abre sozinho se alguém der
    # duplo-clique nele direto, só quando chamado pelo DOS Game Launcher
    # (ou por um atalho de teste passando o parâmetro na mão).
    if IS_WINDOWS and param_lower not in ("phobos", "debug"):
        try:
            _root = tk.Tk()
            _root.withdraw()
            messagebox.showerror(T("panel_title"), T("err_launch_requires_launcher"))
            _root.destroy()
        except Exception:
            pass
        sys.exit(1)

    # "Phobos"  -> tela reduzida (light) + servidor sobe sozinho
    # "Debug" ou nenhum parâmetro (fora do Windows) -> tela Padrão de sempre
    app_mode = "light" if param_lower == "phobos" else "full"
    launch_extra = _get_launch_extra_args()

    app = QuakePanel(mode=app_mode,
                      launch_map=launch_extra["map"],
                      launch_port=launch_extra["port"])
    app.mainloop()