<h1 align="center">🎮 QuakeWorld Server Panel</h1>

<p align="center">
QuakeWorld Server Panel is a lightweight graphical administration tool for the original QuakeWorld Server 2.30 (QWSV).
It provides an intuitive interface to start, stop, configure and monitor a QuakeWorld server, with live player management, RCON administration, map selection, server logs and automatic status monitoring.
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

### ⬇️ Releases

#### 🎮 QuakeWorld Server Panel

```bash
python3 quake_panel.py
```

The panel is distributed as a standalone Python application and uses Python's standard library wherever possible.

#### 🐧 QWSV 2.30 Linux Installer

```bash
curl -fsSL https://raw.githubusercontent.com/joaoandradegp-wq/DOS_Game_Launcher/refs/heads/main/DEV/linux/install_qwsv230.sh | bash
```

> **Recommended:** Use the QWSV installer to prepare the legacy QuakeWorld 2.30 server environment on Linux.
> The Server Panel is an administration layer and does not replace the original QWSV executable.

<br>

| Component                 | Platform            | Version  | Download                                                                                                                                          |
| ------------------------- | ------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| QuakeWorld Server Panel   | **Linux / Windows** | **v1.0** | <a href="https://github.com/joaoandradegp-wq/DOS_Game_Launcher"><b>GitHub Repository</b></a>                                                      |
| QWSV 2.30 Linux Installer | **Linux**           | **v1.0** | <a href="https://raw.githubusercontent.com/joaoandradegp-wq/DOS_Game_Launcher/refs/heads/main/DEV/linux/install_qwsv230.sh"><b>Click here</b></a> |

---

## ✨ Panel Features

<table width="100%">

<tr>

<td width="50%" valign="top">

<h3>🚀 Server Control</h3>

<ul>

<li>Start and stop QuakeWorld Server 2.30 directly from the GUI</li>

<li>Automatic server process detection</li>

<li>Real-time server status monitoring</li>

<li>Configurable server executable</li>

<li>Configurable server directory</li>

<li>Configurable UDP port</li>

<li>Automatic validation of required server files</li>

<li>Server settings are locked while the server is running</li>

</ul>

<br>

</td>

<td width="50%" valign="top">

<h3>⚙️ Server Configuration</h3>

<ul>

<li>Graphical <code>server.cfg</code> management</li>

<li>Hostname</li>

<li>Teamplay</li>

<li>Maximum clients</li>

<li>Maximum spectators</li>

<li>Frag limit</li>

<li>Time limit</li>

<li>Server password</li>

<li>RCON password</li>

<li>Admin information</li>

<li>Server URL</li>

<li>Download settings</li>

<li>Same level / No exit</li>

</ul>

<br>

</td>

</tr>

<tr>

<td width="50%" valign="top">

<h3>👥 Online Players</h3>

<ul>

<li>Live player list</li>

<li>Player names</li>

<li>User IDs</li>

<li>IP addresses</li>

<li>Frags</li>

<li>Automatic player list refresh</li>

<li>Context menu for player administration</li>

</ul>

<p><b>When RCON is available:</b></p>

<ul>

<li>Kick players</li>

<li>Ban player IP addresses</li>

</ul>

<br>

</td>

<td width="50%" valign="top">

<h3>🔐 RCON Administration</h3>

<ul>

<li>Live RCON communication</li>

<li>Server information</li>

<li>Change map</li>

<li>Change frag limit</li>

<li>Change time limit</li>

<li>Send server messages</li>

<li>Kick players</li>

<li>IP ban management</li>

<li>Enable / disable downloads</li>

</ul>

<br>

</td>

</tr>

<tr>

<td width="50%" valign="top">

<h3>🗺️ Map Selection</h3>

<ul>

<li>Graphical map selector</li>

<li>Original Quake episodes</li>

<li>DeathMatch maps</li>

<li>Scourge of Armagon maps</li>

<li>Dissolution of Eternity maps</li>

<li>Maps organized by episode</li>

<li>Last selected map is remembered</li>

</ul>

<p><b>Examples:</b></p>

<pre><code>e1m1
e2m1
e3m1
e4m1
dm1
dm2
dm3
dm4
dm5
dm6</code></pre>

</td>

<td width="50%" valign="top">

<h3>📜 Server Logs</h3>

<ul>

<li>QWSV console output captured automatically</li>

<li>Built-in read-only log viewer</li>

<li>No separate terminal required to monitor the server</li>

<li>Useful for troubleshooting and server monitoring</li>

</ul>

<p><b>Log file:</b></p>

<pre><code>qw_panel.log</code></pre>

<br>

</td>

</tr>

<tr>

<td width="50%" valign="top">

<h3>🌎 Automatic Language Detection</h3>

<ul>

<li>Automatic operating system language detection</li>

<li>Português (Brasil) interface</li>

<li>English interface</li>

<li>No manual language configuration required</li>

</ul>

<p><b>Language detection:</b></p>

<pre><code>pt_BR → Português
Other languages → English</code></pre>

<br>

</td>

<td width="50%" valign="top">

<h3>💾 Persistent Settings</h3>

<ul>

<li>Panel settings stored independently from <code>server.cfg</code></li>

<li>Server directory saved</li>

<li>Executable saved</li>

<li>Port saved</li>

<li>Configuration path saved</li>

<li>Last selected map saved</li>

</ul>

<p><b>Linux:</b></p>

<pre><code>~/.qw_panel_settings.json</code></pre>

</td>

</tr>

</table>

---

## 🎮 QuakeWorld Server Configuration

The panel works directly with the original QWSV configuration system.

### Default Configuration

```text
hostname "K7 QuakeWorld 1998"
deathmatch 1
teamplay 0
maxclients 8
maxspectators 4
timelimit 1
fraglimit 0
```

The panel writes the standard supported configuration fields while preserving additional configuration lines that are not managed directly by the GUI.

---

## 🗺️ Supported Maps

<table width="100%">

<tr>

<td width="50%" valign="top">

<h3>🏰 Original Quake</h3>

<ul>

<li>Welcome to Quake</li>

<li>Dimension of the Doomed</li>

<li>The Realm of Black Magic</li>

<li>The Netherworld</li>

<li>The Elder World</li>

<li>Final Level</li>

</ul>

</td>

<td width="50%" valign="top">

<h3>💀 DeathMatch Arena</h3>

<pre><code>dm1
dm2
dm3
dm4
dm5
dm6</code></pre>

</td>

</tr>

<tr>

<td width="50%" valign="top">

<h3>⚔️ Scourge of Armagon</h3>

<pre><code>hip1m1
hip1m2
hip1m3
hip1m4
hip1m5
hip1m6

hip2m1
hip2m2
hip2m3
hip2m4
hip2m5
hip2m6

hip3m1
hip3m2
hip3m3
hip3m4</code></pre>

</td>

<td width="50%" valign="top">

<h3>🔥 Dissolution of Eternity</h3>

<pre><code>r1m1
r1m2
r1m3
r1m4
r1m5
r1m6

r2m1
r2m2
r2m3
r2m4
r2m5
r2m6</code></pre>

</td>

</tr>

</table>

---

## 🔧 Live Server Administration

When the server is running, the panel provides live administration through RCON.

<table width="100%">

<tr>

<td width="33%" align="center" valign="top">

<h3>🗺️ MAP</h3>

Change the current map using the QWSV 2.30 compatible command:

<pre><code>map dm2</code></pre>

</td>

<td width="33%" align="center" valign="top">

<h3>💬 SAY</h3>

Send messages directly to connected players.

<pre><code>say Hello!</code></pre>

</td>

<td width="33%" align="center" valign="top">

<h3>⏱️ LIMITS</h3>

Change the current:

<pre><code>fraglimit
timelimit</code></pre>

</td>

</tr>

<tr>

<td width="33%" align="center" valign="top">

<h3>🦶 KICK</h3>

Kick a player using the QWSV user ID.

<pre><code>kick &lt;userid&gt;</code></pre>

</td>

<td width="33%" align="center" valign="top">

<h3>🚫 BAN</h3>

Ban an IP address using:

<pre><code>addip &lt;ip&gt;
writeip</code></pre>

</td>

<td width="33%" align="center" valign="top">

<h3>📡 SERVER INFO</h3>

Manage server information:

<pre><code>serverinfo admin
serverinfo url</code></pre>

</td>

</tr>

</table>

> **Important:** This panel targets the original **QWSV 2.30 command set**. Modern QuakeWorld commands are not necessarily available. For example, map changes use `map` instead of `changelevel`.

---

## 🔐 RCON

RCON allows the panel to perform live administrative operations without restarting the server.

<table width="100%">

<tr>

<td width="50%" valign="top">

<h3>🔑 Authentication</h3>

<ul>

<li>RCON password configured through the panel</li>

<li>Password is sent only when performing RCON commands</li>

<li>RCON is required for advanced player administration</li>

</ul>

</td>

<td width="50%" valign="top">

<h3>📡 Communication</h3>

<ul>

<li>Uses the QuakeWorld out-of-band protocol</li>

<li>Communicates directly with QWSV</li>

<li>Supports live server commands</li>

<li>No external administration service required</li>

</ul>

</td>

</tr>

</table>

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

QWSV output is redirected to the panel log file:

```text
qw_panel.log
```

The application provides a built-in read-only log viewer.

This makes it possible to monitor:

<ul>

<li>Server startup</li>

<li>Map changes</li>

<li>Player connections</li>

<li>Player disconnections</li>

<li>Server errors</li>

<li>QWSV console messages</li>

</ul>

---

## 🔄 Server Monitoring

The panel continuously monitors the QWSV process.

<table width="100%">

<tr>

<td width="50%" align="center" valign="top">

<h3>🟢 Server Online</h3>

<ul>

<li>Settings tab is locked</li>

<li>Restart-only fields are disabled</li>

<li>Player list is active</li>

<li>RCON actions become available</li>

<li>Server status is monitored automatically</li>

</ul>

</td>

<td width="50%" align="center" valign="top">

<h3>🔴 Server Offline</h3>

<ul>

<li>Settings tab is unlocked</li>

<li>Player list is cleared</li>

<li>Server files are validated</li>

<li>Start button becomes available</li>

</ul>

</td>

</tr>

</table>

The server state is periodically checked by the application.

---

## 📂 Server Directory Structure

The recommended QuakeWorld installation structure is:

```text
QuakeServer/
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

On Windows:

```text
QuakeServer/
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

The panel validates:

<ul>

<li>Server directory</li>

<li><code>id1</code> directory</li>

<li>Quake <code>.pak</code> files</li>

<li>QWSV executable</li>

</ul>

before enabling the server start operation.

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

```bash
cd /home/phobos/Deimos/QuakeServer
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

<table width="100%">

<tr>

<td width="50%" valign="top">

<h3>📂 Server Directory</h3>

Path containing the QWSV executable and <code>id1</code> directory.

<p><b>Example:</b></p>

<pre><code>/home/phobos/Deimos/QuakeServer</code></pre>

</td>

<td width="50%" valign="top">

<h3>▶️ Executable</h3>

<p><b>Linux:</b></p>

<pre><code>./qwsv</code></pre>

<p><b>Windows:</b></p>

<pre><code>qwsv.exe</code></pre>

</td>

</tr>

<tr>

<td width="50%" valign="top">

<h3>🌐 Server Port</h3>

<p><b>Default:</b></p>

<pre><code>28501</code></pre>

</td>

<td width="50%" valign="top">

<h3>📄 Configuration File</h3>

<p><b>Default:</b></p>

<pre><code>qw/server.cfg</code></pre>

</td>

</tr>

</table>

---

## 📌 Default Settings

<table width="100%">

<tr>

<td width="50%" valign="top">

<h3>🖥️ Server</h3>

<ul>

<li><b>Executable:</b> <code>./qwsv</code></li>

<li><b>Windows:</b> <code>qwsv.exe</code></li>

<li><b>Port:</b> <code>28501</code></li>

<li><b>Configuration:</b> <code>qw/server.cfg</code></li>

<li><b>Initial map:</b> <code>start</code></li>

</ul>

</td>

<td width="50%" valign="top">

<h3>🎮 Game Settings</h3>

<ul>

<li><b>Deathmatch:</b> 1</li>

<li><b>Teamplay:</b> 0</li>

<li><b>Maximum Clients:</b> 8</li>

<li><b>Maximum Spectators:</b> 4</li>

<li><b>Fraglimit:</b> 0</li>

<li><b>Timelimit:</b> Configurable</li>

</ul>

</td>

</tr>

</table>

---

## 🧩 Requirements

<table width="100%">

<tr>

<td width="50%" valign="top">

<h3>🐧 Linux</h3>

<ul>

<li>Linux Mint / Ubuntu or compatible distribution</li>

<li>Python 3</li>

<li>Python Tkinter</li>

<li>i386 compatibility libraries for QWSV 2.30</li>

<li>Original Quake game files</li>

<li>QWSV 2.30 executable</li>

</ul>

<br>

<h4>Required Packages</h4>

<pre><code>sudo apt install python3-tk libc6:i386</code></pre>

</td>

<td width="50%" valign="top">

<h3>🪟 Windows</h3>

<ul>

<li>Windows</li>

<li>Python 3</li>

<li>Tkinter</li>

<li>Original Quake game files</li>

<li>QWSV 2.30 executable</li>

</ul>

<br>

<h4>Run</h4>

<pre><code>python quake_panel.py</code></pre>

</td>

</tr>

</table>

---

## 🛠️ Technologies

<table width="100%">

<tr>

<td width="25%" align="center" valign="middle">

<h3>🐍</h3>

<b>Python</b>

<br><br>

Python 3.x

</td>

<td width="25%" align="center" valign="middle">

<h3>🖼️</h3>

<b>Tkinter</b>

<br><br>

Graphical User Interface

</td>

<td width="25%" align="center" valign="middle">

<h3>🎮</h3>

<b>QuakeWorld</b>

<br><br>

QWSV 2.30

</td>

<td width="25%" align="center" valign="middle">

<h3>🌐</h3>

<b>UDP / RCON</b>

<br><br>

Server communication

</td>

</tr>

</table>

### Main Python Components

<table width="100%">

<tr>

<td width="50%" valign="top">

<pre><code>tkinter
subprocess
socket
signal
threading</code></pre>

</td>

<td width="50%" valign="top">

<pre><code>json
pathlib
platform
re
psutil (optional)</code></pre>

</td>

</tr>

</table>

---

## 📂 Project Structure

```text
DOS_Game_Launcher/
│
├── DEV/
│   └── linux/
│       └── install_qwsv230.sh
│
├── quake_panel.py
│
├── README.md
│
└── ...
```

---

## 🎯 Target Use Cases

<table width="100%">

<tr>

<td width="50%" valign="top">

<ul>

<li>🎮 Classic QuakeWorld servers</li>

<li>🖥️ Home gaming servers</li>

<li>🌐 LAN QuakeWorld servers</li>

<li>🐧 Linux-based game servers</li>

</ul>

</td>

<td width="50%" valign="top">

<ul>

<li>💾 Retro gaming projects</li>

<li>🧪 QuakeWorld development and testing</li>

<li>🏠 Personal dedicated servers</li>

<li>🎯 Small private gaming communities</li>

</ul>

</td>

</tr>

</table>

---

## 🚀 Running QWSV Without the Panel

The panel is **not required** to run the server.

QWSV can still be started directly from the terminal.

### Linux

```bash
cd /home/phobos/Deimos/QuakeServer
./qwsv -port 28501
```

### Windows

```cmd
qwsv.exe -port 28501
```

The Server Panel simply provides a graphical administration layer on top of the existing QWSV installation.

---

## ⚠️ Notes

<ul>

<li>The project is an administration layer for QWSV 2.30 and does not replace the original server executable.</li>

<li>Quake game files are not included in this repository.</li>

<li>You must provide your own legally obtained <code>pak0.pak</code> and <code>pak1.pak</code> files.</li>

<li>QWSV 2.30 is legacy 32-bit software.</li>

<li>Linux systems may require i386 compatibility libraries.</li>

<li>The panel uses Python's standard library wherever possible.</li>

<li>RCON functionality requires a valid RCON password configured on the server.</li>

<li>Some modern QuakeWorld commands are not available in the original QWSV 2.30 command set.</li>

</ul>

---

## 📸 QuakeWorld Server Panel

<p align="center">
  <img width="500" alt="image" src="https://github.com/user-attachments/assets/bbf32666-7c9f-45bd-8ed5-0735a9363ec9" />
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

</p>

<p align="center">
Made for classic QuakeWorld server enthusiasts. 🐧
</p>
