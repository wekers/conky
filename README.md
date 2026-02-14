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

> **Status:** Stable  
> **Current Version:** v2.0  
> **Legacy Version:** v1.10 (Lua-based, archived)

---

## Language

- 🇺🇸 You are reading the English version.
- 🇧🇷 [Portuguese version](README.pt-BR.md)

---

> **Version 2.0** – Complete migration from legacy Conky 1.10 + Lua to a **pure Conky 1.22+ configuration**, no language Lua required.

This project provides a **modern, elegant, and highly customizable Conky setup**, featuring:

- 🌦️ Weather (OpenWeatherMap)
- 🌙 Moon phases (local generation, no NASA dependency)
- 📊 CPU / RAM / Disk / Network monitoring
- 🧩 NVIDIA GPU stats (optional)
- 🖥️ Multi-resolution layouts (1080p / 2K)
- 🌍 Multi-language support (EN / PT-BR auto-detected)
- ❌ Fully **Lua-free** configuration
- 🚀 Compatible with **AppImage** (no installation required)

## 📦 Repository Structure

```css
conky/
├── conkyrc/
│   ├── .conkyrc_1080p
│   └── .conkyrc_2k
├── images/
│   ├── weather icons
│   └── wind icons
├── fonts/
├── printscreen/
├── time.sh
├── GetMoon.sh
├── lune_die.sh
├── moon.pl
├── moon_age.pl
├── moon_texture.jpg
├── conky.sh
└── README.md
```

---

## 🚀 Supported Versions

| Version            | Status    | Description               |
| ------------------ | --------- | ------------------------- |
| **v2.0 (main)**    | ✅ Active | Conky **1.22+**, Lua-free |
| **v1.10 (legacy)** | 🧊 Frozen | Conky **1.10**, Lua-based |

Legacy support is preserved in:

- **Branch:** `legacy-1.10`
- **Tag:** `v1.10-legacy`

---

## Versioning

This project follows **Semantic Versioning** and documents all notable changes
in [CHANGELOG.md](CHANGELOG.md).

## 🖥️ Screenshots

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

## 🔧 Requirements

### Mandatory

- **Conky ≥ 1.22**
- `curl`
- `xmllint`
- `perl`
- `lm-sensors`

### Optional (GPU)

- `nvidia-smi` (for NVIDIA GPUs)

---

## 🌦️ OpenWeatherMap API

Weather data uses **OpenWeatherMap XML API**.

> The first **1,000 API calls per day are FREE**

### 1️⃣ Create your API key

👉 [https://openweathermap.org/api](https://openweathermap.org/api)

### 2️⃣ Create secrets file

```bash
mkdir -p ~/.config/conky
nano ~/.config/conky/secrets.conf
chmod 600 ~/.config/conky/secrets.conf
```

```ini
OWM_APPID=YOUR_API_KEY_HERE
```

The key is **never hardcoded** in `.conkyrc`.

---

## 🌙 Moon Phase System (Offline)

Moon phases are generated **locally**, no HTTP requests.

- Replaces the old NASA-based solution
- Works on **both v1.10 and v2.0**
- Supports PT-BR translation automatically

Scripts involved:

- `GetMoon.sh`
- `lune_die.sh`
- `moon.pl`
- `moon_age.pl`

Internal Scripts

- `time.sh`  
  Central weather, wind, moon, and localization logic.
  All data parsing and language switching happens here.

---

## ⚙️ Installation Options

---

### Option A – AppImage (Recommended & Easy)

No installation required.

```bash
git clone https://github.com/wekers/conky.git
cd conky
# download AppImage from https://github.com/brndnmtthws/conky/releases
chmod +x conky-ubuntu-24.04-x86_64-v1.22.2.AppImage

./conky-ubuntu-24.04-x86_64-v1.22.2.AppImage -c conkyrc/.conkyrc_2k
```

Or for Full HD:

```bash
./conky-ubuntu-24.04-x86_64-v1.22.2.AppImage -c conkyrc/.conkyrc_1080p
```

---

### Option B – Compile from Source (Advanced)

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

## ▶️ Running Conky

```bash
./conky.sh
```

or manually:

```bash
conky -c conkyrc/.conkyrc_2k
```

---

## 🌍 Language Support

Language is auto-detected via `LANG`.

| LANG    | Output    |
| ------- | --------- |
| `pt_BR` | Português |
| others  | English   |

Applies to:

- Weather labels
- Moon phases
- Wind descriptions

---

## 🧠 Design Philosophy (v2.0)

This project was fully refactored in version 2.0 due to:

- Upstream API changes (NASA / Moon data)
- Conky Lua instability and maintenance cost
- Desire for a portable, AppImage-friendly setup

Version 2.0 removes all Lua dependencies and relies only on:
Bash, Perl (local), and native Conky features.

- ❌ No Lua
- ✅ Native Conky objects
- ✅ Portable configs
- ✅ Easier maintenance
- ✅ Compatible with Wayland & X11
- ✅ Secure secrets handling

---

## 🧊 Legacy Version (Conky 1.10)

If you still use Conky 1.10:

```bash
git checkout legacy-1.10
```

Tag:

```bash
git checkout v1.10-legacy
```

---

## 📜 License

MIT License  
© Fernando Gilli
