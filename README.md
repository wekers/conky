# Conky – Modern Desktop Monitor (Lua-free, Conky ≥ 1.22)

![Version](https://img.shields.io/github/v/tag/wekers/conky?label=version)
![Release](https://img.shields.io/github/release/wekers/conky)
![License](https://img.shields.io/github/license/wekers/conky)
![Conky](https://img.shields.io/badge/Conky-1.22+-blue)
![Lua](https://img.shields.io/badge/Lua-not%20required-success)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)
![Issues](https://img.shields.io/github/issues/wekers/conky)
![Last Commit](https://img.shields.io/github/last-commit/wekers/conky)

---
### A fully portable, Lua-free Conky setup with automated installation and cross-distribution support.
---
> **Status:** Stable  
> **Version:** v2.1.0  
> **Philosophy:** Minimal dependencies, maximum portability

---

## Language

- 🇺🇸 You are reading the English version.
- 🇧🇷 [Portuguese version](README.pt-BR.md)

---

## ✨ Overview

A **modern, elegant and fully Lua-free Conky setup**, designed for:

- ⚡ portability (AppImage-ready)
- 🧩 modular scripts
- 🌍 multi-language support
- 🖥️ multi-resolution layouts

## 🎯 Why this project?

Most Conky setups rely on Lua and hardcoded paths.

This project provides:
- A Lua-free architecture
- Fully portable scripts
- Cross-distribution compatibility
- Simple installation and maintenance

### Features

- 🌦️ OpenWeatherMap integration (XML API)
- 🌙 Offline moon phase rendering (no external APIs)
- 📊 CPU / RAM / Disk / Network monitoring
- 🧠 Smart localization (EN / PT-BR auto-detected)
- 🖥️ 1080p and 2K layouts
- 🎮 Optional NVIDIA GPU support
- ❌ No Lua scripting required

---

## 📸 Screenshots

### 1080p

| EN                                            | PT-BR                                            |
| --------------------------------------------- | ------------------------------------------------ |
| ![print](printscreen/Conky-1.22-1080p-US.png) | ![print](printscreen/Conky-1.22-1080p-pt-BR.png) |

### 2K / 2560×1440

| EN                                         | PT-BR                                         |
| ------------------------------------------ | --------------------------------------------- |
| ![print](printscreen/Conky-1.22-2k-US.png) | ![print](printscreen/Conky-1.22-2k-pt-BR.png) |

### Fullscreen

![print](printscreen/Conky-1.22-2k-FullScreen-pt-BR.png)

---


## 📦 Repository Structure

```css
conky/
├── conkyrc/
│   ├── .conkyrc_1080p
│   └── .conkyrc_2k
├── images/
│   ├── weather icons
│   └── wind icons
├── CHANGELOG.md
├── LICENSE
├── conky-1.22.2.tar.gz
├── fonts/
├── printscreen/
├── init.sh
├── install.sh
├── time.sh
├── GetMoon.sh
├── lune_die.sh
├── moon.pl
├── moon_age.pl
├── moon_texture.jpg
├── conky.sh
├── README.pt-BR.md
└── README.md
```

---

## 🚀 Quick Start (Recommended)
- ### 🌦️ OpenWeatherMap API
  - Weather data uses **OpenWeatherMap XML API**.

    > The first **1,000 API calls per day are FREE**

- ### 1️⃣ Create your API key

  👉 [https://openweathermap.org/api](https://openweathermap.org/api)

### 2️⃣ Clone the Project:
```bash
git clone https://github.com/wekers/conky.git
cd conky

# Install dependencies automatically
./install.sh

# Configure your API key
nano ~/.config/conky/secrets.conf

# Start Conky
./conky.sh
```


### 3️⃣ Configure your API key and your city (city,country):
```ini
OWM_APPID=YOUR_API_KEY
OWM_CITY=Sacramento,US
```
The key is **never hardcoded** in `.conkyrc`.

### 4️⃣ Run:

```bash
./conky.sh # start (default)
./conky.sh start

./conky.sh stop
./conky.sh restart
```

---

## 🐧 Supported Distributions

- Ubuntu / Debian
- Linux Mint
- Fedora
- Arch Linux
- Slackware

The `install.sh` script automatically detects your distribution and installs the correct dependencies.

---

## ⚙️ Configuration

### 🌐 Network Interface

Auto-detection command:

```bash
ip route 2>/dev/null | awk '/default/ {print $5; exit}'
```

Edit in `.conkyrc`:

```lua
template0 = 'eth0'
```

Common values:

| Interface | Description       |
|----------|------------------|
| eth0     | Legacy ethernet  |
| enp0s3   | Modern ethernet  |
| wlp2s0   | Wi-Fi            |

---

### 🌍 Weather Configuration

File:

```bash
~/.config/conky/secrets.conf
```

Example:

```ini
OWM_APPID=YOUR_API_KEY
OWM_CITY=Salvador,BR
```

---

### 🌙 Moon Hemisphere Fix

If you are in the **Northern Hemisphere**, edit:

```bash
GetMoon.sh
```

Change:

```bash
HEMISPHERE="s"
```

to:

```bash
HEMISPHERE="n"
```

---

## 🧠 Architecture

```text
conky.sh
   └── init.sh (weather bootstrap)
          └── time.sh (core logic)
                 ├── weather parsing
                 ├── localization
                 ├── wind + units
                 └── moon integration
                        └── GetMoon.sh
                               └── perl scripts
```

### Core Components

| Script        | Responsibility |
|--------------|---------------|
| conky.sh     | lifecycle (start/stop/restart) |
| init.sh      | weather initialization |
| time.sh      | central processing engine |
| GetMoon.sh   | moon rendering |
| *.pl         | astronomical calculations |

---

## ▶️ Usage

```bash
./conky.sh start
./conky.sh stop
./conky.sh restart
```

---

## 🔧 Requirements

### Mandatory

- Conky ≥ 1.22
- curl
- lm-sensors
- bc
- imagemagick
- libxml2-utils (xmllint)
- perl + Astro::MoonPhase

### Optional

- nvidia-smi (GPU stats)

---

## 🧩 Installation Options

---

### [Option A - Quick Start (Recommended)](#-quick-start-recommended) ☝️

---

### Option B – AppImage (Alternative Easy Method)
- Download AppImage from https://github.com/brndnmtthws/conky/releases
#### Required dependencies:
- curl
- lm-sensors
- bc
- imagemagick
- libxml2-utils (xmllint)
- perl + Astro::MoonPhase

```bash
Run once:

./init.sh

Then:

chmod +x conky-*.AppImage
./conky-*.AppImage -c conkyrc/.conkyrc_2k
or
./conky-*.AppImage -c conkyrc/.conkyrc_1080p
```

---

### Option C - Compile From Source (Advanced)

#### Pre-install

```bash
pip3 install pyyaml Jinja2
```

#### Build

```bash
tar -zxvf conky-1.22.2.tar.gz
cd conky-1.22.2
mkdir build && cd build

cmake \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_DOCS=OFF \
  -DBUILD_EXTRAS=ON \
  -DBUILD_XDBE=ON \
  -DBUILD_CURL=ON \
  -DBUILD_WLAN=ON \
  -DBUILD_RSS=ON \
  -DBUILD_PULSEAUDIO=ON \
  -DBUILD_MPD=ON \
  -DBUILD_IMLIB2=ON \
  -DBUILD_LUA_CAIRO=ON \
  -DBUILD_LUA_IMLIB2=ON \
  -DBUILD_WAYLAND=ON \
  -DBUILD_MOUSE_EVENTS=ON \
  -DCMAKE_BUILD_TYPE=Release ..

make
sudo make install
```
---
## 🪟 Windows (WSL2 Support)

This project works on WSL2 (Windows 10/11), with some limitations.

### Supported
- Weather
- Moon phases
- System information (partial)
- Full Conky rendering

### Limitations
- No hardware sensors (CPU temperature, etc.)
- No `hddtemp` support
- Limited system-level metrics

### Recommendation
- WSL is supported for testing and development.
- For full functionality, use **native Linux**.

---

## 🌍 Language Support

Auto-detected via `LANG`.

| LANG    | Output    |
|--------|----------|
| pt_BR  | Portuguese |
| others | English   |

Applies to:

- Weather labels
- Moon phases
- Wind descriptions

---

## 🛠️ Troubleshooting

### ❌ Weather not showing

- Check API key
- Check city format: `city,country`
- Validate XML cache:

```bash
cat ~/.cache/weather_current.xml
```

---

### ❌ Conky not starting

- Ensure scripts are executable:

```bash
chmod +x *.sh
```

- NEVER use:

```bash
sh script.sh
```

Use:

```bash
./script.sh
```

---

### ❌ Network showing 0

- Wrong interface in `template0`
- Run detection command (see above)

---

### ❌ Moon rendering inverted

- Fix hemisphere in `GetMoon.sh`

---

### ❌ xmllint not found

- Install:

```bash
sudo apt install libxml2-utils
```

---

### ❌ Astro::MoonPhase not found


- Install:

```bash
sudo cpanm Astro::MoonPhase
```

---

### ❌ No sensors found

- Run:

```bash
sudo sensors-detect
```


---
## 🚀 Supported Versions

| Version            | Status    | Description               |
| ------------------ | --------- | ------------------------- |
| **v2.1.0 (main)**    | ✅ Active | Conky **1.22+**, Lua-free configuration |
| **v1.10 (legacy)** | 🧊 Frozen | Conky **1.10**, Lua-based Language |

Legacy support is preserved in:

- **Branch:** `legacy-1.10`
- **Tag:** `v1.10-legacy`

---

## Versioning

This project follows **Semantic Versioning** and documents all notable changes
in [CHANGELOG.md](CHANGELOG.md).

---

## 🧠 Design Philosophy (v2.0)

This project was fully refactored in version 2.0 due to:

- Upstream API changes (NASA / Moon data)
- Conky Lua instability and maintenance cost
- Desire for a portable, AppImage-friendly setup

Version 2.0 removes all Lua language dependencies and relies only on:
Bash, Perl (local), and native Conky features.

- ❌ No Lua scripting required
- ✅ Native Conky objects
- ✅ Portable configs
- ✅ Easier maintenance
- ✅ Compatible with Wayland & X11
- ✅ Secure secrets handling

---

## 🧊 Legacy Version

```bash
git checkout legacy-1.10
```

---
## 📄 License / Usage
MIT — License. 

Feel free to:
- clone
- modify
- adapt it to your needs
  
* * *

### 👉 If this project helped you, a ⭐ in the repository is worth a coffee. ☕🙂

* * *
© WeKeRs