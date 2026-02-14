# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [2.0.0] – 2026-02-08

### Added

- Lua-free Conky architecture (no `conky.lua` required)
- Native Conky 1.22 configuration
- Local moon phase rendering (no external NASA dependency)
- Weather support via OpenWeatherMap XML API
- Multi-resolution layouts:
  - FullHD (1920×1080)
  - 2K / QHD (2560×1440)
- AppImage compatibility for easy usage without system install
- Environment-based secret loading (`OWM_APPID`)
- Language auto-detection (pt_BR / en_US)

### Changed

- Project version bumped from 1.10 → 2.0 due to architectural changes
- Weather icons logic rewritten
- CPU layout redesigned with multi-column responsive layout
- File Systems block rewritten using native Conky variables

### Removed

- Dependency on `conky.lua`
- Lua-based filesystem rendering
- External moon phase HTTP requests

### Deprecated

- Lua-based configuration (legacy only)

### Security

- Removed hardcoded API keys

---

## [1.10.0] – 2025-07-28

### Added

- Lua-based filesystem rendering
- Moon phase rendering via external sources
- Legacy Conky 1.10 compatibility

### Deprecated

- Lua-based architecture (superseded in v2.0)

---
