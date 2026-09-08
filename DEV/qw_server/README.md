<h1 align="center"><img width="32" alt="image" src="https://github.com/user-attachments/assets/051f3e0d-6c82-4089-9f54-f597b60108d3" /> QuakeWorld Server Panel</h1>

<p align="center">
  <b>Graphical administration panel for QuakeWorld Server 2.30</b>
</p>

<p align="center">
  A lightweight server management component of the <b>DOS Game Launcher</b>.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/QuakeWorld-2.30-red">
  <img src="https://img.shields.io/badge/Linux%20%7C%20Windows-blue">
  <img src="https://img.shields.io/badge/Python-3.x-purple">
  <img src="https://img.shields.io/badge/Tkinter-green">
  <img src="https://img.shields.io/badge/UDP%20%7C%20RCON-orange">
</p>

---

## ✨ About

**QuakeWorld Server Panel** is the server administration component used by the **DOS Game Launcher** to manage the original **QuakeWorld Server 2.30 (QWSV)**.

It provides a graphical interface for:

* 🚀 Starting and stopping the server
* ⚙️ Editing `server.cfg`
* 🗺️ Selecting maps
* 👥 Monitoring connected players
* 🔐 RCON administration
* 📡 Server status monitoring
* 📜 Viewing the server log
* 🌎 PT-BR / English interface

The panel works on **Linux and Windows**.

---

## 🚀 Linux Installation

The recommended installation method is the automated installer:

```bash
curl -fsSL https://raw.githubusercontent.com/joaoandradegp-wq/DOS-Game_Launcher/refs/heads/main/DEV/qw_server/install.sh | bash
```

The installer:

1. Checks Python 3, Tkinter and `wget`
2. Installs PyInstaller when necessary
3. Installs the required i386 compatibility library
4. Downloads QWSV 2.30
5. Downloads and builds `qw_panel.py`
6. Installs the standalone `qw_panel` executable
7. Creates a desktop shortcut

The installer asks for the server folder name. The default is:

```text
~/QuakeWorld/
```

The resulting structure is:

```text
~/QuakeWorld/
├── qwsv
├── id1/
└── qw/
```

The panel executable is installed at:

```text
~/.local/bin/qw_panel
```

The installer creates a desktop launcher named **QuakeWorld Server** as well.

### ▶️ Start manually

```bash
qw_panel
```

If `~/.local/bin` is not in `PATH`, the installer displays the required command to add it.

---

## 🪟 Windows

The panel can also be executed directly with Python:

```cmd
python qw_panel.py
```

The expected server structure is:

```text
QUAKE/
├── qwsv.exe
├── id1/
│   ├── pak0.pak
│   └── pak1.pak
└── qw/
    └── server.cfg
```

Tkinter is included with the standard Python Windows installation.

---

## 🎮 DOS Game Launcher Integration

The panel was designed to work together with the **DOS Game Launcher**.

* Uses a compact interface
* Displays connected players
* Starts the server automatically
* Uses the map and port supplied by the Launcher

The command-line parameters are handled directly by the panel.

---

## ⚙️ Features

### Server

* Start / stop QWSV 2.30
* Automatic process detection
* ONLINE / OFFLINE status
* Configurable server directory
* Configurable executable
* Configurable UDP port
* Automatic validation of `id1`

### Configuration

Edit the main `server.cfg` settings directly from the GUI:

* Hostname
* Teamplay
* Max players
* Max spectators
* Frag limit
* Time limit
* Server password
* RCON password
* Server information
* Downloads
* Same level
* No exit

Additional configuration lines are preserved when the file is saved.

### Players

Player information is obtained through the QuakeWorld UDP `status` protocol.

The panel displays:

* Player name
* User ID
* IP address
* Frags

Right-clicking a player provides RCON actions such as:

* Kick
* Ban by IP

### RCON

Live administration without restarting the server:

* Change map
* Send messages
* Change frag/time limits
* Update server information
* Enable/disable downloads
* Kick players
* Ban IP addresses

---

## 🗺️ Maps

The panel includes the original Quake maps organized by episode, including:

* Original Quake
* DeathMatch Arena
* Scourge of Armagon
* Dissolution of Eternity

The selected map is remembered by the panel.

---

## 📜 Logs

QWSV output is redirected to:

```text
qw_panel.log
```

The panel includes a built-in read-only log viewer.

---

## 🌎 Languages

The interface automatically detects the operating system language:

* 🇧🇷 Portuguese (Brazil)
* 🇺🇸 English

Portuguese is selected when the system language is `pt-BR`; other languages fall back to English.

---

## 📦 Requirements

### Linux

* Python 3
* Python Tkinter
* `wget`
* PyInstaller
* `sudo`
* i386 compatibility support
* Original Quake game files

The automated installer handles the QWSV 2.30 32-bit compatibility setup.

### Windows

* Windows
* Python 3
* Tkinter
* QWSV 2.30
* Original Quake game files

---

## ⚠️ Quake Game Files

Quake game data is **not included**.

You must provide your own legally obtained:

```text
pak0.pak
pak1.pak
```

Place them inside:

```text
<server>/id1/
```

The panel checks that the `id1` directory contains at least one `.pak` file before starting the server.

---

## 🛠️ Technology

* **Python 3**
* **Tkinter**
* **QuakeWorld Server 2.30**
* **UDP**
* **RCON**
* **PyInstaller**

The Linux installer builds `qw_panel.py` as a standalone executable using PyInstaller.

---

## 📸 Screenshot

<p align="center">
  <img width="500" alt="QuakeWorld Server Panel" src="https://github.com/user-attachments/assets/bbf32666-7c9f-45bd-8ed5-0735a9363ec9" />
</p>

---

<p align="center">
  🎮 <b>QuakeWorld 2.30 · DOS Game Launcher</b><br>
  Classic server administration.
</p>
