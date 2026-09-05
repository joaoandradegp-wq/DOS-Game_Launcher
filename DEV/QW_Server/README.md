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
