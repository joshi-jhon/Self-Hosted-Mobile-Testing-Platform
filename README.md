Self-Hosted Mobile Testing Platform

100% Free | Firebase / BrowserStack Alternative

📌 Overview

This repository provides a fully self-hosted Android Mobile Testing Platform built on open-source tools.
It is designed for teams that do not want paid cloud services like Firebase Test Lab, BrowserStack, or Sauce Labs.

It supports:

Android emulators (auto-scaled)

Appium 2 automation

Device management via DeviceFarmer

CI/CD execution (Jenkins / GitHub Actions)

Network throttling (2G → 5G)

Performance benchmarking

Per-test video recording

Metrics & dashboards (Prometheus + Grafana)

Secure, reboot-safe, production deployment

🏗️ Architecture
┌────────────────────────────┐
│   Nginx Proxy Manager      │
│   (SSL / Auth / RBAC)      │
└───────────┬────────────────┘
            │ HTTPS
            ▼
┌──────────────────────────────────────────┐
│            Ubuntu Server 22.04            │
│                                          │
│  DeviceFarmer  ←→  Appium 2 Grid          │
│       ▲               ▲                  │
│       │ ADB           │ WebDriver         │
│  Emulator Pool  ←→  Auto-Scaler           │
│                                          │
│  tc/netem  (Network Throttling)           │
│                                          │
│  Prometheus  ←→  Grafana                  │
└──────────────────────────────────────────┘

✅ What Is Installed
🧩 Core Components
Component	Purpose
Android SDK + Emulator	Runs Android Virtual Devices (AVDs)
DeviceFarmer	Device broker & UI
Appium 2	Mobile automation server
UiAutomator2 / Espresso	Android automation drivers
ADB	Android device communication
Auto-Scaler (systemd)	Spins emulators up/down
tc / netem	Network shaping
scrcpy + ffmpeg	Screen recording
Prometheus	Metrics collection
Grafana	Dashboards & visualization
UFW Firewall	Security hardening
📂 Directory Layout
/
├── /opt/android-sdk          # Android SDK & emulator
├── /opt/appium               # Appium configuration
│   └── appium.yaml
├── /opt/devicefarmer         # DeviceFarmer source
├── /usr/local/bin
│   ├── emulator-scaler.sh
│   └── netem-profile.sh
├── /etc/systemd/system
│   ├── appium.service
│   ├── emulator-scaler.service
│   └── emulator-scaler.timer
└── /var/log
    └── devicefarm-install.log

🚀 Services & Ports
Service	Port	Notes
Appium	4723	Bound to localhost
DeviceFarmer	7100	Accessed via Nginx Proxy Manager
Grafana	3000	Dashboard UI
Prometheus	9090	Metrics
🔌 Appium ↔ DeviceFarmer Wiring

DeviceFarmer only exposes ADB devices.
Appium automatically detects devices via ADB.

Desired Capabilities Example
{
  "platformName": "Android",
  "automationName": "UiAutomator2",
  "udid": "DEVICE_UDID",
  "app": "/apps/app.apk"
}


✅ No plugins
✅ No custom bridges
✅ Clean ADB handoff

🔄 Emulator Auto-Scaling
Behavior

Starts emulators only when needed

Stops idle emulators automatically

CPU / RAM aware

Runs every 30 seconds via systemd timer

Manual Commands
# Check running emulators
adb devices

# Manually start scaler
/usr/local/bin/emulator-scaler.sh

# View scaler logs
journalctl -u emulator-scaler.service

🌐 Network Throttling

Apply realistic network conditions per test suite.

Available Profiles
Profile	Command
2G	netem-profile.sh 2G
3G	netem-profile.sh 3G
4G	netem-profile.sh 4G
5G	netem-profile.sh 5G
Reset Network
tc qdisc del dev eth0 root

🎥 Video Recording
Manual Recording
scrcpy --record /recordings/test_$(date +%s).mp4

Appium API
driver.startRecordingScreen();
// test steps
driver.stopRecordingScreen();


Artifacts are stored per CI build.

📊 Metrics & Dashboards
Metrics Tracked

Emulator CPU & RAM

App launch time

Test duration

Failures per build

Device utilization

Access
Grafana: http://<server-ip>:3000
Prometheus: http://<server-ip>:9090


Import provided Grafana JSON dashboards for instant visibility.

🧪 CI/CD Integration
Jenkinsfile
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

GitHub Actions (Self-Hosted)
runs-on: self-hosted
steps:
  - uses: actions/checkout@v4
  - run: mvn test

🔐 Security Hardening

✔ Appium bound to 127.0.0.1
✔ Firewall only allows 443, 7100, SSH
✔ Non-root emulator user
✔ No USB passthrough
✔ CI secrets isolated
✔ Read-only SDK directories
✔ Reboot-safe systemd services

🛠️ Troubleshooting Guide
Appium
systemctl status appium
journalctl -u appium -f
appium driver list

ADB / Emulators
adb kill-server
adb start-server
adb devices
ps aux | grep emulator

DeviceFarmer
cd /opt/devicefarmer
npm start

Network Issues
tc qdisc show dev eth0
ip addr show

Performance Debugging
adb shell dumpsys meminfo com.app.package
adb shell dumpsys gfxinfo com.app.package
adb shell top

Logs
tail -f /var/log/devicefarm-install.log
journalctl -xe

🔁 Reboot Safety

All critical components run as systemd services:

systemctl list-unit-files | grep enabled


Reboot-safe ✔
Crash-resistant ✔
Auto-recovery ✔

🎯 What This Platform Gives You

✅ Internal Firebase Test Lab
✅ Unlimited test executions
✅ No vendor lock-in


📣 Support

This platform is designed to be operated entirely in-house.
If something breaks — you control every layer.

Welcome to your internal mobile testing cloud. 🚀
✅ Zero cloud cost
✅ Enterprise-grade reliability
✅ Full control over devices & data
