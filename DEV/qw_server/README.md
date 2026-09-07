<h1 align="center">🎮 QuakeWorld Server Panel</h1>

<p align="center">
  <b>A modern graphical administration panel for the original QuakeWorld Server 2.30</b>
</p>

<p align="center">
  Start, stop, configure and monitor your QuakeWorld server through a simple graphical interface.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Stable-success">
  <img src="https://img.shields.io/badge/QuakeWorld-2.30-red">
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue">
  <img src="https://img.shields.io/badge/Python-3.x-purple">
  <img src="https://img.shields.io/badge/GUI-Tkinter-green">
  <img src="https://img.shields.io/badge/Protocol-UDP%20%7C%20RCON-orange">
</p>

---

## ✨ Overview

**QuakeWorld Server Panel** is a lightweight graphical administration tool for the original **QuakeWorld Server 2.30 (QWSV)**.

It provides an intuitive graphical interface to:

* 🚀 Start and stop the QuakeWorld server
* ⚙️ Configure `server.cfg`
* 👥 Monitor connected players
* 🔐 Administrate the server through RCON
* 🗺️ Select Quake maps
* 📜 View the server log
* 📡 Monitor server status
* 🌎 Automatically detect the operating system language
* 🌓 Switch between **Standard** and **Light** display modes

The panel acts as an **administration layer** on top of the original QWSV executable. It does not replace the server itself.

---

## 🚀 Quick Installation — Linux

The easiest way to install the complete QuakeWorld Server Panel environment on Linux is to use the automated installer.

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/joaoandradegp-wq/DOS-Game_Launcher/refs/heads/main/DEV/qw_server/install.sh | bash
```

The installer automatically:

1. Checks for Python 3
2. Checks for Python Tkinter
3. Checks for `wget`
4. Installs PyInstaller for the current user if necessary
5. Enables the `i386` architecture
6. Installs the 32-bit `libc6` compatibility library
7. Downloads **QWSV 2.30**
8. Creates the QuakeWorld server directory
9. Downloads the latest `qw_panel.py`
10. Compiles the panel using PyInstaller
11. Installs the `qw_panel` executable
12. Makes the panel available from `~/.local/bin`

### 📂 Installation location

The Linux installer creates the server environment at:

```text
~/Deimos/QuakeServer/
```

The QWSV executable is installed as:

```text
~/Deimos/QuakeServer/qwsv
```

The panel executable is installed as:

```text
~/.local/bin/qw_panel
```

### ▶️ Starting the panel

After installation:

```bash
qw_panel
```

If `~/.local/bin` is not already in your `PATH`, the installer will display the command required to add it:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then run:

```bash
qw_panel
```

---

## ⚠️ Quake Game Files

The installer **does not include copyrighted Quake game data**.

You must provide your own legally obtained:

```text
pak0.pak
pak1.pak
```

Copy them to:

```text
~/Deimos/QuakeServer/id1/
```

The final structure should look like:

```text
~/Deimos/QuakeServer/
│
├── qwsv
│
├── id1/
│   ├── pak0.pak
│   └── pak1.pak
│
└── qw/
    └── server.cfg
```

The installer checks whether the `pak0.pak` and `pak1.pak` files exist. If they are missing, it displays a warning instructing you to copy your legally obtained files into the `id1` directory.

---

## 🐧 Linux Installer

### Automated installer

The recommended installation method is:

```bash
curl -fsSL https://raw.githubusercontent.com/joaoandradegp-wq/DOS-Game_Launcher/refs/heads/main/DEV/qw_server/install.sh | bash
```

### What the installer requires

The installer checks for:

* Python 3
* Python Tkinter
* `wget`
* `pip3`
* PyInstaller

If PyInstaller is not available, it attempts to install it for the current user:

```bash
pip3 install --user pyinstaller
```

### QWSV 2.30 compatibility

The original QWSV 2.30 server is a legacy **32-bit Linux executable**.

The installer automatically enables i386 support:

```bash
sudo dpkg --add-architecture i386
sudo apt update
```

and installs the required compatibility library:

```bash
sudo apt install -y libc6:i386
```

No manual execution of these commands is necessary when using the automated installer.

---

## 🪟 Windows Installation

The panel also supports Windows.

Install Python 3 and run the Python source directly:

```cmd
python qw_panel.py
```

The standard Python Windows installer normally includes Tkinter.

The panel automatically uses:

```text
qwsv.exe
```

when running on Windows.

The expected structure is:

```text
QUAKE/
│
├── qwsv.exe
│
├── id1/
│   ├── pak0.pak
│   └── pak1.pak
│
└── qw/
    └── server.cfg
```

---

## ✨ Panel Features

### 🚀 Server Control

The panel provides complete basic server control directly from the GUI.

* Start and stop QWSV 2.30
* Automatic server process detection
* Real-time server status monitoring
* Configurable server executable
* Configurable server directory
* Configurable UDP port
* Validation of required server files
* Protection of restart-only settings while the server is running

---

### ⚙️ Server Configuration

The graphical configuration interface manages the main `server.cfg` parameters.

#### Available settings

* Hostname
* Teamplay
* Maximum clients
* Maximum spectators
* Frag limit
* Time limit
* Server password
* RCON password
* Admin information
* Server URL
* Download settings
* Same level
* No exit

The panel writes the supported configuration fields while preserving additional configuration lines that are not directly managed by the GUI.

---

### 👥 Online Players

The panel provides a live player list containing:

* Player names
* User IDs
* IP addresses
* Frags
* Automatic player list refresh

A context menu is available for player administration.

When RCON is available:

* Kick players
* Ban player IP addresses

The panel can also query the server directly through the standard QuakeWorld UDP `status` protocol.

---

### 🔐 RCON Administration

RCON provides live server administration without restarting QWSV.

Available operations include:

* Server information
* Change map
* Change frag limit
* Change time limit
* Send server messages
* Kick players
* Ban player IP addresses
* Enable / disable downloads

RCON communication is performed directly between the panel and the QuakeWorld server.

No external administration service is required.

---

## 🔧 Live Server Administration

When the server is running, the panel can perform live administration through RCON.

### 🗺️ Change Map

The panel uses the QWSV 2.30-compatible command:

```text
map dm2
```

### 💬 Send Server Message

```text
say Hello!
```

### ⏱️ Change Limits

```text
fraglimit
timelimit
```

### 🦶 Kick Player

Players can be kicked using their QWSV user ID:

```text
kick <userid>
```

### 🚫 Ban IP Address

IP bans use:

```text
addip <ip>
writeip
```

followed by:

```text
writeip
```

### 📡 Server Information

Server information can be managed using:

```text
serverinfo admin
serverinfo url
```

> **Important:** This project targets the original **QWSV 2.30 command set**. Modern QuakeWorld commands are not necessarily available.

---

## 🗺️ Map Selection

The panel includes a graphical map selector with maps organized by episode.

### Original Quake

* Welcome to Quake
* Dimension of the Doomed
* The Realm of Black Magic
* The Netherworld
* The Elder World
* Final Level
* DeathMatch Arena

### Scourge of Armagon

Includes the maps from the **Hipnotic** mission pack.

### Dissolution of Eternity

Includes the maps from the **Rogue** mission pack.

The last selected map is remembered by the panel.

---

## 🌓 Display Modes

The panel supports two interface modes.

### ◱ Standard Mode

The complete administration interface is displayed, including:

* Server configuration
* Server controls
* Map selection
* RCON administration
* Server information
* Player list
* Server status
* Log viewer

### ◱ Light Mode

A reduced interface designed primarily for monitoring the running server.

The Light Mode focuses on:

* Server status
* Connected players
* Player count
* Player administration
* Quick switching back to Standard Mode

The Light Mode can also be used when the panel is launched by the **DOS Game Launcher**.

---

## 📡 Server Communication

The panel communicates directly with QWSV using the QuakeWorld UDP protocol.

### Server Status

The panel sends the classic QuakeWorld:

```text
status
```

request.

The response is parsed to retrieve server and player information.

### Player Information

Depending on the available response and RCON access, the panel can display:

```text
Player Name
User ID
IP Address
Frags
```

---

## 📜 Server Logs

QWSV output is redirected to:

```text
qw_panel.log
```

The panel provides a built-in read-only log viewer.

The log can be used to monitor:

* Server startup
* Map changes
* Player connections
* Player disconnections
* Server errors
* QWSV console messages

No separate terminal is required to monitor the server.

---

## 🔄 Server Monitoring

The panel continuously monitors the QWSV process.

### 🟢 Server Online

When the server is running:

* Restart-only configuration fields are disabled
* Player monitoring is active
* RCON administration is available
* Server status is monitored automatically
* The running server process is detected automatically

### 🔴 Server Offline

When the server is stopped:

* Configuration becomes available
* Player information is cleared
* Server files are validated
* The Start button becomes available

---

## 📂 Server Directory Structure

### Linux

The automated installer uses:

```text
~/Deimos/QuakeServer/
│
├── qwsv
│
├── id1/
│   ├── pak0.pak
│   └── pak1.pak
│
└── qw/
    └── server.cfg
```

### Windows

```text
QUAKE/
│
├── qwsv.exe
│
├── id1/
│   ├── pak0.pak
│   └── pak1.pak
│
└── qw/
    └── server.cfg
```

Before starting the server, the panel validates the server directory and the `id1` directory.

---

## ⚙️ Panel Settings

The **Settings** tab allows the QWSV installation parameters to be changed.

### 📂 Server Directory

The directory containing the QWSV executable and `id1` folder.

Linux default:

```text
~/Deimos/QuakeServer
```

### ▶️ Executable

**Linux**

```text
./qwsv
```

**Windows**

```text
qwsv.exe
```

### 🌐 Server Port

Default:

```text
28501
```

### 📄 Configuration File

Default:

```text
qw/server.cfg
```

---

## 🧩 Requirements

### 🐧 Linux

For the automated installer:

* Linux Mint, Ubuntu or compatible distribution
* Python 3
* Python Tkinter
* `wget`
* `pip3`
* Internet connection
* Ability to use `sudo`
* i386 compatibility support
* Original Quake game files

The installer automatically handles the QWSV 2.30 32-bit compatibility requirements.

### 🪟 Windows

* Windows
* Python 3
* Tkinter
* Original Quake game files
* QWSV 2.30 Windows executable

---

## 🛠️ Technologies

| Technology              | Purpose                      |
| ----------------------- | ---------------------------- |
| 🐍 Python 3.x           | Application logic            |
| 🖼️ Tkinter             | Graphical User Interface     |
| 🎮 QuakeWorld QWSV 2.30 | Game server                  |
| 🌐 UDP                  | Server communication         |
| 🔐 RCON                 | Remote administration        |
| 📦 PyInstaller          | Linux standalone panel build |

---

## 🎯 Target Use Cases

The panel is designed for:

* 🎮 Classic QuakeWorld servers
* 🖥️ Home gaming servers
* 🌐 LAN QuakeWorld servers
* 🐧 Linux-based game servers
* 💾 Retro gaming projects
* 🧪 QuakeWorld development and testing
* 🏠 Personal dedicated servers
* 🎯 Small private gaming communities

---

## 🚀 Running QWSV Without the Panel

The panel is **not required** to run the server.

QWSV can still be started directly from the terminal.

### Linux

```bash
cd ~/Deimos/QuakeServer
./qwsv -port 28501
```

### Windows

```cmd
qwsv.exe -port 28501
```

The Server Panel simply provides a graphical administration layer on top of the existing QWSV installation.

---

## 📦 What the Linux Installer Does

The automated installer performs the complete setup required for the panel and server.

### Server

```text
QWSV 2.30
    ↓
i386 compatibility
    ↓
~/Deimos/QuakeServer/
```

### Panel

```text
qw_panel.py
    ↓
PyInstaller
    ↓
~/.local/bin/qw_panel
```

The installer uses a temporary working directory for the panel build and removes it automatically when the installation finishes.

If QWSV 2.30 is already installed at:

```text
~/Deimos/QuakeServer/qwsv
```

the installer skips downloading and reinstalling it.

---

## ⚠️ Notes

* This project is an administration layer for QWSV 2.30 and does not replace the original server executable.
* Quake game files are **not included** in this repository.
* You must provide your own legally obtained `pak0.pak` and `pak1.pak`.
* QWSV 2.30 is legacy 32-bit software.
* Linux requires i386 compatibility support to run the original QWSV binary.
* The Linux installer automatically enables i386 support and installs `libc6:i386`.
* The installer builds the Linux panel using PyInstaller.
* The resulting Linux panel binary is installed under `~/.local/bin`.
* RCON functionality requires a valid RCON password configured on the server.
* Some modern QuakeWorld commands are not available in the original QWSV 2.30 command set.
* The panel detects the operating system language and supports **PT-BR** and **English**.
* The installer does not download or distribute copyrighted Quake game data.

---

## 📸 QuakeWorld Server Panel

<p align="center">
  <img width="500" alt="QuakeWorld Server Panel" src="https://github.com/user-attachments/assets/bbf32666-7c9f-45bd-8ed5-0735a9363ec9" />
</p>

---

## 🔗 Project

**GitHub Repository:**

https://github.com/joaoandradegp-wq/DOS-Game_Launcher

**Linux Installer:**

```bash
curl -fsSL https://raw.githubusercontent.com/joaoandradegp-wq/DOS-Game_Launcher/refs/heads/main/DEV/qw_server/install.sh | bash
```

---

## 📜 License & Disclaimer

This repository contains the graphical administration panel and supporting scripts.

It does **not** include copyrighted Quake game data.

Quake and QuakeWorld are properties of their respective rights holders.

Users are responsible for obtaining and using the original game files legally.

---

<p align="center">
  🎮 <b>QuakeWorld 2.30 · Classic Server · Modern Administration</b><br>
  Made for classic QuakeWorld server enthusiasts. 🐧
</p>
