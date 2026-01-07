# 📱 Self-Hosted Mobile Testing Platform  
### 100% Free • Firebase / BrowserStack / Sauce Labs Alternative • Enterprise-Grade

---

## 📌 Overview

This repository provides a **fully self-hosted Android Mobile Testing Platform** built entirely using **open-source tools**.

It is designed for organizations that:

- Do **not** want paid cloud testing platforms
- Need **full control** over devices, data, and CI pipelines
- Want **enterprise-grade reliability** without vendor lock-in
- Require **scalable, reproducible, reboot-safe** infrastructure

This platform is suitable for **internal QA teams**, **DevOps teams**, and **CI/CD pipelines**.

---

## 🏗️ Final Production Architecture

```
┌─────────────────────────┐
│   Nginx Proxy Manager   │
│   (SSL / Auth / RBAC)   │
└──────────┬──────────────┘
           │ HTTPS
           ▼
┌──────────────────────────────────────────────────────────┐
│                    MOBILE TESTING VM                      │
│                  Ubuntu Server 22.04                      │
│                                                          │
│ ┌────────────┐   ┌─────────────┐   ┌─────────────────┐ │
│ │DeviceFarmer│◄──►│ Appium Grid │◄──►│ Jenkins / GHA   │ │
│ │ UI + ADB   │   │ Appium 2    │   │ Pipelines       │ │
│ └────────────┘   └─────────────┘   └─────────────────┘ │
│       ▲                   ▲                             │
│       │ ADB               │ WebDriver                   │
│ ┌────────────┐     ┌──────────────┐                     │
│ │Emulator Pool│◄───►│ Auto-Scaler  │                     │
│ │(AVDs)      │     │ (systemd)    │                     │
│ └────────────┘     └──────────────┘                     │
│       │                                                  │
│ ┌────────────┐                                          │
│ │ tc/netem   │  Network Throttling                      │
│ └────────────┘                                          │
│                                                          │
│ ┌────────────┐   ┌─────────────┐                        │
│ │ Prometheus │◄──►│ Grafana     │                        │
│ └────────────┘   └─────────────┘                        │
└──────────────────────────────────────────────────────────┘
```

---

## ✅ Tool Stack (All Free & Open Source)

| Area | Tool |
|----|----|
| Device management | DeviceFarmer |
| Automation | Appium 2 |
| Drivers | UiAutomator2, Espresso |
| CI/CD | Jenkins / GitHub Actions |
| Emulators | Android Emulator (AVD) |
| Auto-scaling | systemd + bash |
| Network shaping | tc + netem |
| Metrics | Prometheus |
| Dashboards | Grafana |
| Recording | scrcpy + ffmpeg |
| Auth / SSL | Nginx Proxy Manager |
| Firewall | UFW |

---

## 🚀 One-Click Installation (Production-Grade)

This project includes a **single, production-ready, idempotent Bash installer** that installs, configures, secures, and runs **everything** on **Ubuntu Server 22.04**.

### ✨ Installer Guarantees

The script is:

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
- ✔ OS validation (Ubuntu 22.04)
- ✔ OpenJDK 17
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
- ✔ Automatic ADB discovery

### 🔄 Auto-Scaling
- ✔ Emulator auto-scaler
- ✔ systemd service + timer
- ✔ CPU / RAM aware
- ✔ Idle emulator cleanup

### 📊 Observability
- ✔ Prometheus
- ✔ Grafana
- ✔ Metrics endpoints enabled

### 🎥 Test Artifacts
- ✔ scrcpy screen recording
- ✔ ffmpeg encoding
- ✔ Per-test video support

### 🌐 Network Simulation
- ✔ tc + netem
- ✔ 2G / 3G / 4G / 5G profiles

### 🔐 Security Hardening
- ✔ Appium bound to localhost
- ✔ UFW firewall rules
- ✔ Non-root Android user
- ✔ Reboot-safe systemd services

---

## ⚡ One-Click Install

### 📄 Script

```
install-device-farm.sh
```

### ▶️ Run

```bash
sudo bash install-device-farm.sh
```

- ⏱ Install time: ~10–15 minutes  
- 📜 Logs: `/var/log/devicefarm-install.log`

---

## 🧪 Verify Installation (2 Minutes)

```bash
appium driver list
adb devices
systemctl status appium
systemctl status emulator-scaler.timer
```

Expected:
- Appium drivers listed
- Emulator visible via ADB
- All services running

---

## 🔌 Appium ↔ DeviceFarmer Wiring

DeviceFarmer acts purely as an **ADB broker**.  
Appium automatically picks up all devices exposed via ADB.

### Example Desired Capabilities

```json
{
  "platformName": "Android",
  "automationName": "UiAutomator2",
  "udid": "DEVICEFARMER_DEVICE_UDID",
  "app": "/apps/app.apk"
}
```

---

## 🔄 Emulator Auto-Scaling

- Emulators spin up only when tests run
- Idle emulators are terminated
- Managed by systemd timer

### Manual Commands

```bash
adb devices
journalctl -u emulator-scaler.service
```

---

## 🌐 Network Throttling

### Apply Profiles

```bash
netem-profile.sh 2G
netem-profile.sh 3G
netem-profile.sh 4G
netem-profile.sh 5G
```

### Reset Network

```bash
tc qdisc del dev eth0 root
```

---

## 🎥 Video Recording

### Manual

```bash
scrcpy --record /recordings/test_$(date +%s).mp4
```

### Appium API

```java
driver.startRecordingScreen();
driver.stopRecordingScreen();
```

---

## 📊 Metrics & Dashboards

Metrics tracked:

- Emulator CPU / RAM
- App launch time
- Test duration
- Failures per build
- Device utilization

Access:
- Grafana → `http://<server-ip>:3000`
- Prometheus → `http://<server-ip>:9090`

---

## 🧪 CI/CD Integration

### Jenkinsfile

```groovy
pipeline {
  agent any
  stages {
    stage('Test') {
      steps {
        sh 'mvn test -Dappium.server=http://localhost:4723'
      }
    }
  }
}
```

### GitHub Actions (Self-Hosted)

```yaml
runs-on: self-hosted
steps:
  - uses: actions/checkout@v4
  - run: mvn test
```

---

## 🛠️ Troubleshooting

### Appium

```bash
systemctl status appium
journalctl -u appium -f
```

### Emulator / ADB

```bash
adb kill-server
adb start-server
adb devices
```

### Network

```bash
tc qdisc show dev eth0
```

### Logs

```bash
tail -f /var/log/devicefarm-install.log
journalctl -xe
```

---

## 🔁 Reboot Safety

All components run as **systemd services** and automatically recover after reboot.

---

## 📜 License

This project is licensed under the **Apache License 2.0**.

You are free to use, modify, and distribute this software for internal or commercial use,
provided you comply with the license terms.

See the `LICENSE` file for details.

---

## 🎯 What This Gives You

- ✅ Internal Firebase Test Lab
- ✅ Unlimited Android test runs
- ✅ Zero cloud cost
- ✅ Full CI/CD integration
- ✅ Enterprise-grade reliability
- ✅ Complete control over devices and data
