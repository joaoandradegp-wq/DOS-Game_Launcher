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

It provides an intuitive interface to:

* 🚀 Start and stop the server
* ⚙️ Configure `server.cfg`
* 👥 Monitor connected players
* 🔐 Manage the server through RCON
* 🗺️ Select maps
* 📜 View server logs
* 📡 Monitor server status
* 🌎 Automatically detect the operating system language

The panel acts as an **administration layer** on top of the original QWSV executable. It does not replace the server itself.

---

## ⬇️ Releases

### 🎮 QuakeWorld Server Panel

Run the panel with:

```bash
python3 quake_panel.py
```

The panel is distributed as a standalone Python application and uses Python's standard library wherever possible.

### 🐧 QWSV 2.30 Linux Installer

The repository also provides an installer for the original 32-bit QWSV 2.30 Linux server:

```bash
curl -fsSL https://raw.githubusercontent.com/joaoandradegp-wq/DOS_Game_Launcher/refs/heads/main/DEV/linux/install_qwsv230.sh | bash
```

> **Recommended:** Use the QWSV installer to prepare the legacy QuakeWorld 2.30 server environment on Linux.

| Component                 | Platform        | Version |
| ------------------------- | --------------- | ------- |
| QuakeWorld Server Panel   | Linux / Windows | v1.0    |
| QWSV 2.30 Linux Installer | Linux           | v1.0    |

**Project:** <a href="https://github.com/joaoandradegp-wq/DOS_Game_Launcher"><b>GitHub Repository</b></a>

**Linux Installer:** <a href="https://raw.githubusercontent.com/joaoandradegp-wq/DOS_Game_Launcher/refs/heads/main/DEV/linux/install_qwsv230.sh"><b>Click here</b></a>

---

## ✨ Panel Features

### 🚀 Server Control

The panel provides complete basic server control directly from the GUI.

* Start and stop QuakeWorld Server 2.30
* Automatic server process detection
* Real-time server status monitoring
* Configurable server executable
* Configurable server directory
* Configurable UDP port
* Automatic validation of required server files
* Server settings locked while the server is running

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
* Same level / No exit

The panel writes the standard supported configuration fields while preserving additional configuration lines that are not managed directly by the GUI.

---

### 👥 Online Players

The panel provides a live player list containing:

* Player names
* User IDs
* IP addresses
* Frags
* Automatic player list refresh

A context menu is available for player administration.

#### When RCON is available

* Kick players
* Ban player IP addresses

If RCON is unavailable, the panel automatically falls back to the standard UDP status query and displays the information available through that response.

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
* IP ban management
* Enable / disable downloads

---

### 🗺️ Map Selection

The panel includes a graphical map selector with maps organized by episode.

#### Original Quake

* Welcome to Quake
* Dimension of the Doomed
* The Realm of Black Magic
* The Netherworld
* The Elder World
* Final Level

#### DeathMatch Arena

#### Scourge of Armagon

#### Dissolution of Eternity

The last selected map is remembered by the panel.

---

## 🔧 Live Server Administration

When the server is running, the panel provides live administration through RCON.

### 🗺️ Change Map

The panel uses the QWSV 2.30 compatible command:

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

IP bans are performed using:

```text
addip <ip>
writeip
```

### 📡 Server Information

Server information can be managed using:

```text
serverinfo admin
serverinfo url
```

> **Important:** This panel targets the original **QWSV 2.30 command set**. Modern QuakeWorld commands are not necessarily available. For example, map changes use `map` instead of `changelevel`.

---

## 🔐 RCON

RCON allows the panel to perform live administrative operations without restarting the server.

### Authentication

* RCON password configured through the panel
* Password is sent only when performing RCON commands
* RCON is required for advanced player administration

### Communication

* Uses the QuakeWorld out-of-band protocol
* Communicates directly with QWSV
* Supports live server commands
* No external administration service required

### RCON Command Format

```text
rcon "<password>" <command>
```

If RCON is unavailable, the panel automatically falls back to the standard UDP status query.

---

## 📡 Server Communication

The panel communicates directly with the QuakeWorld server using UDP.

### Server Status

The panel sends the classic QuakeWorld status request:

```text
status
```

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

The application provides a built-in read-only log viewer.

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

* Settings tab is locked
* Restart-only fields are disabled
* Player list is active
* RCON actions become available
* Server status is monitored automatically

### 🔴 Server Offline

When the server is stopped:

* Settings tab is unlocked
* Player list is cleared
* Server files are validated
* Start button becomes available

The server state is periodically checked by the application.

---

## 📂 Server Directory Structure

The recommended QuakeWorld installation structure is:

### Linux

```text
QUAKE/
│
├── qwsv
│
├── id1/
│   ├── pak0.pak
│   └── pak1.pak
│
└── qw/
    ├── qwprogs.dat
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
    ├── qwprogs.dat
    └── server.cfg
```

Before enabling the Start operation, the panel validates:

* Server directory
* `id1` directory
* Quake `.pak` files
* QWSV executable

---

## 🐧 Linux Installation

### 1. Enable i386 Architecture

The original QWSV 2.30 executable is a legacy 32-bit Linux binary.

```bash
sudo dpkg --add-architecture i386
sudo apt update
```

### 2. Install Compatibility Libraries

```bash
sudo apt install libc6:i386
```

### 3. Install Tkinter

```bash
sudo apt install python3-tk
```

### 4. Run the Panel

```bash
python3 quake_panel.py
```

### 5. Run QWSV Manually

Navigate to your QuakeWorld server directory:

```bash
./qwsv -port 28501
```

---

## 🪟 Windows Installation

Install Python 3 and run:

```cmd
python quake_panel.py
```

The standard Python Windows installer normally includes Tkinter.

The panel automatically uses:

```text
qwsv.exe
```

as the default Windows server executable.

---

## ⚙️ Panel Settings

The **Settings** tab allows the QWSV installation parameters to be changed.

### 📂 Server Directory

Path containing the QWSV executable and `id1` directory.

Example:

```text
/path/to/QuakeServer
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

* Linux Mint / Ubuntu or compatible distribution
* Python 3
* Python Tkinter
* i386 compatibility libraries for QWSV 2.30
* Original Quake game files
* QWSV 2.30 executable

#### Required Packages

```bash
sudo apt install python3-tk libc6:i386
```

### 🪟 Windows

* Windows
* Python 3
* Tkinter
* Original Quake game files
* QWSV 2.30 executable

#### Run

```cmd
python quake_panel.py
```

---

## 🛠️ Technologies

| Technology              | Purpose                  |
| ----------------------- | ------------------------ |
| 🐍 Python 3.x           | Application logic        |
| 🖼️ Tkinter             | Graphical User Interface |
| 🎮 QuakeWorld QWSV 2.30 | Game server              |
| 🌐 UDP / RCON           | Server communication     |

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
cd /QuakeServer
./qwsv -port 28501
```

### Windows

```cmd
qwsv.exe -port 28501
```

The Server Panel simply provides a graphical administration layer on top of the existing QWSV installation.

---

## ⚠️ Notes

* The project is an administration layer for QWSV 2.30 and does not replace the original server executable.
* Quake game files are not included in this repository.
* You must provide your own legally obtained `pak0.pak` and `pak1.pak` files.
* QWSV 2.30 is legacy 32-bit software.
* Linux systems may require i386 compatibility libraries.
* The panel uses Python's standard library wherever possible.
* RCON functionality requires a valid RCON password configured on the server.
* Some modern QuakeWorld commands are not available in the original QWSV 2.30 command set.

---

## 📸 QuakeWorld Server Panel

<p align="center">
  <img width="500" alt="QuakeWorld Server Panel" src="https://github.com/user-attachments/assets/bbf32666-7c9f-45bd-8ed5-0735a9363ec9" />
</p>

---

## 📜 License & Disclaimer

This repository contains the graphical administration panel and supporting scripts.

It does **not** include copyrighted Quake game data.

Quake and QuakeWorld are properties of their respective rights holders.

Users are responsible for obtaining and using the original game files legally.

---

<p align="center">
🎮 <b>QuakeWorld 2.30 · Classic Server · Modern Administration</b>
Made for classic QuakeWorld server enthusiasts. 🐧
</p>
