<p align="center">
  <img width="450" alt="DOS Game Launcher" src="https://github.com/user-attachments/assets/ed2a3292-8e02-478e-9099-de46a2fe23b4" />
</p>

<p align="center">
DOS Game Launcher is a front-end app built on DOSBox, ZDoom, QuakeSpasm and QuakeWorld to emulate MS-DOS games, providing multiplayer support and seamless execution on modern Windows systems.
It was designed to automatically configure and adapt each game to make use of new enhancements available for MS-DOS titles without losing their original feel. The app optimizes CPU cycles, memory, and graphic resolutions for every certified game on the platform, while enabling multiplayer gameplay over LAN or the internet.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Active-success">
  <img src="https://img.shields.io/badge/Platform-Windows-blue">
  <img src="https://img.shields.io/badge/Games-DOS-orange">
  <img src="https://img.shields.io/badge/Languages-PT--BR%20%7C%20EN-purple">
</p>

---

## 📀 Game Compatibility

**DOS Game Launcher does not include any copyrighted game files.**

The launcher is compatible with game data from:

- ✅ Original CD-ROM releases
- ✅ GOG releases

> Simply provide your legally obtained game files, and **DOS Game Launcher** will automatically recognize and configure them.

---

## ✨ Features

<table style="border: none; border-collapse: collapse;">
<tr>
<td width="50%" valign="top" style="border: none; padding: 15px;">
  
### 🎮 SUPPORTED GAMES

It offers integration with the following games in their original or GOG versions:

<ul>
<li>BLOOD
  <ul>
    <li>ONE UNIT WHOLE BLOOD</li>
  </ul>
</li>

<li>CONSTRUCTOR</li>

<li>THE ULTIMATE DOOM
  <ul>
    <li>SIGIL + SOUNDTRACK</li>
    - BUCKETHEAD FILES SUPPORTED
    <li>SIGIL II + SOUNDTRACK</li>
    - THORR FILES SUPPORTED
  </ul>
</li>

<li>DOOM II
  <ul>
    <li>MODS SUPPORTED</li>
  </ul>
</li>

<li>DUKE NUKEM 3D
  <ul>
    <li>ATOMIC EDITION</li>
  </ul>
</li>

<li>HERETIC
  <ul>
    <li>SHADOW OF THE SERPENT RIDERS</li>
  </ul>
</li>

<li>HEXEN
  <ul>
    <li>BEYOND HERETIC</li>
  </ul>
</li>

<li>QUAKE
  <ul>
    <li>SCOURGE OF ARMAGON (Mission Pack)</li>
    <li>DISSOLUTION OF ETERNITY (Mission Pack)</li>
  </ul>
</li>

<li>RISE OF THE TRIAD
  <ul>
    <li>DARK WAR</li>
  </ul>
</li>

<li>SHADOW WARRIOR
  <ul>
    <li>WANTON DESTRUCTION</li>
    <li>TWIN DRAGON</li>
  </ul>
</li>

<li>WARCRAFT II
  <ul>
    <li>BEYOND THE DARK PORTAL</li>
  </ul>
</li>

<li>WOLFENSTEIN 3D
  <ul>
    <li>SPEAR OF DESTINY</li>
  </ul>
</li>
</ul>
<br>
</td>

<td width="50%" valign="top" style="border: none; padding: 15px;">

### 🌐 MULTIPLAYER

<ul>
<li><b>SERVER:</b><br>
Choose your in-game name, select the number of players, and provide your Local or Internet IP address along with the connection Port to the other players.
</li>
<br>
<li><b>CLIENT:</b><br>
Choose your in-game name, select the number of players, and then enter the IP address and connection Port provided by the server host.
</li>
</ul>

</td>
</tr>

<tr>
<td width="50%" valign="top" style="border: none; padding: 15px;">

### ⚙️ CONFIGURATIONS

DOS Game Launcher automatically applies optimized settings for each available game.

<ul>
<li>Automatic Selections:
  <ul>
    <li>One-Click Multiplayer Connection</li>
  </ul>
</li>

<li>Optimized Selections:
  <ul>
    <li>Episodes and Chapters</li>
    <li>Colors/Skins and Classes</li>
    <li>Dedicated Server (QuakeWorld)</li>
    <li>Graphic Resolution:
      <ul>
        <li>NOLFBLIM (VESA)</li>
        <li>SVGA_S3</li>
        <li>QUAKESPASM (Source Port)</li>
      </ul>
    </li>
    <li>W,A,S,D Keyboard Layout</li>
    <li>FreeLook Mouse
      <ul>
        <li>BMOUSE (v0.6)</li>
      </ul>
    </li>
  </ul>
</li>

<li>DOS Extender:
  <ul>
    <li>DOS32A (v9.1.2)</li>
  </ul>
</li>
</ul>

</td>

<td width="50%" valign="top" style="border: none; padding: 15px;">

### 🧩 SUPPORTED PLATFORMS

<ul>
<li>DOSBox 0.74<br>www.dosbox.com</li>
<li>ZDOOM 2.8.1<br>www.zdoom.org</li>
<li>QuakeSpasm 0.96.3<br>www.quakespasm.sourceforge.net</li>
<li>QuakeWorld 2.30<br>www.doomworld.com</li><br>
</ul>

### 🔥 FIREWALL RULES

On first launch after installation, DOS Game Launcher automatically adds a Windows Firewall exception rule to allow Server and/or Client mode.

These rules apply only to DOSBox, ZDoom and Quakespasm platform connections.<br>
<br>
### 🐞 DEBUG MODE

<ul>
<li>Displays parameters sent to platforms</li>
<li>System-defined paths</li>
<li>Generated configuration files</li>
</ul>

<b>Access:</b><br>
OPTIONS >> DEBUG MODE  

Any errors found in the system can be reported on GitHub Issues.
<br><br>
</td>
</tr><br>
</table>

---

## 🌐 QuakeWorld 2.30 Server (Linux)

This project includes an installer for the **original QuakeWorld 2.30 dedicated server (QWSV)** released in 1998.

The original **i386 Linux QWSV binary** runs on modern 64-bit Linux systems using 32-bit compatibility libraries.

<p align="center">
  <img src="https://img.shields.io/badge/QuakeWorld-2.30-red">
  <img src="https://img.shields.io/badge/Server-QWSV%201998-orange">
  <img src="https://img.shields.io/badge/Platform-Linux-blue">
  <img src="https://img.shields.io/badge/Architecture-i386-purple">
</p>

### 🐧 Installation

The installer automatically:

- Enables i386 architecture
- Installs libc6:i386
- Creates the required server directories
- Installs QWSV 2.30
- Includes qwprogs.dat
- Sets executable permissions

<p align="center">
  <a href="https://raw.githubusercontent.com/joaoandradegp-wq/DOS-Game_Launcher/refs/heads/main/DEV/linux/install_qwsv230.sh">
    <img src="https://img.shields.io/badge/Download-QWSV%202.30%20Installer-blue?style=for-the-badge">
  </a>
</p>

Installation:

    curl -fsSL https://raw.githubusercontent.com/joaoandradegp-wq/DOS-Game_Launcher/refs/heads/main/DEV/linux/install_qwsv230.sh -o install_qwsv230.sh
    chmod +x install_qwsv230.sh
    ./install_qwsv230.sh

### 📁 Required Files

After installation, copy your legally obtained Quake game files to:

    ~/Deimos/QuakeServer/id1/

| File | Location | Status |
|------|----------|--------|
| pak0.pak | id1/ | Required |
| pak1.pak | id1/ | Required |
| qwprogs.dat | qw/ | Included |
| server.cfg | qw/ | Optional |

The final structure should be:

    QuakeServer/
    ├── qwsv
    ├── id1/
    │   ├── pak0.pak
    │   └── pak1.pak
    └── qw/
        ├── qwprogs.dat
        └── server.cfg

> qwprogs.dat is already included with the QWSV Linux installation.

### ▶️ Start the Server

    cd ~/Deimos/QuakeServer
    ./qwsv -port 28501

**Default port:** UDP 28501

### 🗺️ Classic Map Rotation

The original QWSV 2.30 uses the classic deathmatch rotation:

**DM1 → DM2 → DM3 → DM4 → DM5 → DM6 → DM1**

Match duration can be configured with:

    timelimit 15

The configuration file is located at:

    ~/Deimos/QuakeServer/qw/server.cfg

> **The project does not include copyrighted Quake game files.**

---

## 📸 Preview

<p align="center">
<img width="350" alt="image" src="https://github.com/user-attachments/assets/af947d81-cf40-4dae-8cca-146e230df1d9" />
<img width="350" alt="image" src="https://github.com/user-attachments/assets/5c23250a-5b50-4aca-aaf8-de6e7fb8c746" />
<br>
<img width="350" alt="image" src="https://github.com/user-attachments/assets/5af7a0b4-9206-4aa9-85a3-def380501092" />
<img width="350" alt="image" src="https://github.com/user-attachments/assets/6d5cf482-d945-42c9-ac5f-05a04604b23b" />
<br>
<img width="350" alt="image" src="https://github.com/user-attachments/assets/88630226-b228-4521-9954-aa28759aff26" />
<img width="350" alt="image" src="https://github.com/user-attachments/assets/9f9a78b2-a85e-40e0-8905-3ae7beba89a7" />
<br>
<img width="350" alt="image" src="https://github.com/user-attachments/assets/856a21a5-329c-4085-a52d-b1f02822b498" />
<img width="350" alt="image" src="https://github.com/user-attachments/assets/43b33c82-5c6d-4217-8a25-ef620d7ce44b" />
</p>

---
<p align="center">
Made for classic gaming enthusiasts. 🕹️
</p>
