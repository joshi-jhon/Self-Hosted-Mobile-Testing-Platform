# 📱 Self-Hosted Mobile Testing Platform
### 100% Free • Firebase / BrowserStack Alternative • Enterprise-Grade

---

## 📌 Overview

This repository provides a **fully self-hosted Android Mobile Testing Platform** built entirely using **open-source tools**.

It is designed for teams that **do not want paid cloud services** like Firebase Test Lab, BrowserStack, or Sauce Labs, and want **full control** over devices, data, and CI pipelines.

---

## 🏗️ Architecture

┌────────────────────────────┐
│ Nginx Proxy Manager │
│ (SSL / Auth / RBAC) │
└───────────┬────────────────┘
│ HTTPS
▼
┌──────────────────────────────────────────┐
│ Ubuntu Server 22.04 │
│ │
│ DeviceFarmer ←→ Appium 2 Grid │
│ ▲ ▲ │
│ │ ADB │ WebDriver │
│ Emulator Pool ←→ Auto-Scaler │
│ │
│ tc/netem (Network Throttling) │
│ │
│ Prometheus ←→ Grafana │
└──────────────────────────────────────────┘


---

## 🚀 One-Click Installation (Production-Grade)

This project includes a **single, production-ready, idempotent Bash installer** that installs, configures, secures, and runs **the entire Mobile Testing Platform** on **Ubuntu Server 22.04**.

### ✨ Installer Guarantees

The installation script is:

- ✅ 100% self-hosted
- ✅ Reboot-safe
- ✅ Error-handled
- ✅ Non-interactive
- ✅ Idempotent (safe to re-run)
- ✅ Enterprise-ready

> Run **ONE SCRIPT** and you get a **Firebase / BrowserStack-class internal Device Farm**.

---

## 📦 What the Installer Does (Automatically)

### 🔧 System & Runtime
- ✔ OS validation (Ubuntu Server 22.04)
- ✔ Java (OpenJDK 17)
- ✔ Node.js & npm
- ✔ Core system utilities

### 📱 Android Stack
- ✔ Android SDK & Platform Tools
- ✔ Android Emulator
- ✔ Pre-configured AVDs
- ✔ Non-root emulator execution

### 🧪 Automation
- ✔ Appium 2 (global install)
- ✔ UiAutomator2 & Espresso drivers
- ✔ Appium bound to `127.0.0.1`

### 🧩 Device Management
- ✔ DeviceFarmer (ADB broker + UI)
- ✔ Automatic ADB discovery by Appium

### 🔄 Auto-Scaling
- ✔ Emulator auto-scaler
- ✔ systemd service + timer
- ✔ CPU / RAM aware scaling
- ✔ Idle emulator cleanup

### 📊 Observability
- ✔ Prometheus
- ✔ Grafana
- ✔ Metrics endpoints enabled

### 🎥 Test Artifacts
- ✔ scrcpy screen capture
- ✔ ffmpeg video recording
- ✔ Per-test recording support

### 🌐 Network Simulation
- ✔ `tc` + `netem`
- ✔ 2G / 3G / 4G / 5G profiles

### 🔐 Security Hardening
- ✔ UFW firewall rules
- ✔ Appium localhost-only binding
- ✔ Non-root Android user
- ✔ Reboot-safe systemd services

---

## ⚡ One-Click Install

### 📄 Script

install-device-farm.sh


### ▶️ Run

```bash
sudo bash install-device-farm.sh

⏱️ Install time: ~10–15 minutes

📜 Logs: /var/log/devicefarm-install.log



🧪 Verify Installation (2 Minutes)

# Verify Appium drivers
appium driver list

# Verify emulator availability
adb devices

# Check Appium service
systemctl status appium

# Check emulator auto-scaler
systemctl status emulator-scaler.timer


Expected:

Appium drivers listed (uiautomator2, espresso)

Emulator visible in adb devices

Services running and enabled

🔌 Appium ↔ DeviceFarmer Wiring

DeviceFarmer acts as a pure ADB broker.
Appium automatically picks up devices exposed via ADB.

Example Capabilities

{
  "platformName": "Android",
  "automationName": "UiAutomator2",
  "udid": "DEVICE_UDID",
  "app": "/apps/app.apk"
}


🔄 Emulator Auto-Scaling

Emulators start only when tests run

Idle emulators are cleaned automatically

Managed by systemd timers

Manual Commands
adb devices
journalctl -u emulator-scaler.service


🌐 Network Throttling
Apply Profiles
netem-profile.sh 2G
netem-profile.sh 3G
netem-profile.sh 4G
netem-profile.sh 5G

Reset
tc qdisc del dev eth0 root

🎥 Video Recording
Manual
scrcpy --record /recordings/test_$(date +%s).mp4

Appium API
driver.startRecordingScreen();
driver.stopRecordingScreen();

📊 Metrics & Dashboards

Emulator CPU / RAM

App launch time

Test duration

Failures per build

Device utilization

Access:

Grafana → http://<server-ip>:3000

Prometheus → http://<server-ip>:9090

🔐 Security Model

Appium bound to localhost

Firewall restricted ports

No USB passthrough

CI secrets isolated

Optional AppArmor / SELinux

🛠️ Troubleshooting
Appium
systemctl status appium
journalctl -u appium -f

Emulator / ADB
adb kill-server
adb start-server
adb devices

Network
tc qdisc show dev eth0

Logs
tail -f /var/log/devicefarm-install.log
journalctl -xe

🔁 Reboot Safety

All components run as systemd services and automatically recover after reboot.

📜 License

This project is licensed under the Apache License 2.0.

You are free to use, modify, and distribute this software for internal or commercial use,
in compliance with the license terms.

See the LICENSE file for details.

🎯 Final Result

✅ Internal Firebase Test Lab
✅ Unlimited test runs
✅ Zero cloud cost
✅ Full CI/CD integration
✅ Enterprise-grade reliability


---

If you want next, I can:
- Add `CONTRIBUTING.md`
- Add `SECURITY.md`
- Add a **Quick Start (First Test in 5 minutes)**
- Add **Real Device over LAN** guide
- Add **Grafana JSON dashboards**

Just say the word 🚀
