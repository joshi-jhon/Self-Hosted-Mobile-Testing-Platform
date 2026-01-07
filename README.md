🚀 One-Click Installation (Production-Grade)

This project includes a single, production-ready, idempotent Bash installer that installs, configures, secures, and runs the entire Mobile Testing Platform on Ubuntu Server 22.04.

✨ Installer Guarantees

The installation script is:

✅ 100% self-hosted (no paid services, no cloud lock-in)

✅ Reboot-safe (systemd managed)

✅ Error-handled (fails fast with clear logs)

✅ Non-interactive (CI & automation friendly)

✅ Idempotent (safe to re-run multiple times)

✅ Enterprise-ready

Run ONE SCRIPT and you get a Firebase / BrowserStack-class internal Device Farm.

📦 What the Installer Does (Automatically)

The script performs full system provisioning end-to-end:

🔧 System & Runtime

✔ OS validation (Ubuntu Server 22.04)

✔ Java (OpenJDK 17)

✔ Node.js & npm

✔ System dependencies & tooling

📱 Android Stack

✔ Android SDK & Platform Tools

✔ Android Emulator

✔ Pre-configured AVDs

✔ Non-root emulator execution

🧪 Automation

✔ Appium 2 (global install)

✔ UiAutomator2 & Espresso drivers

✔ Appium bound to 127.0.0.1 (secure by default)

🧩 Device Management

✔ DeviceFarmer (ADB broker + UI)

✔ Automatic ADB discovery by Appium

🔄 Auto-Scaling

✔ Emulator auto-scaler

✔ systemd service + timer

✔ CPU / RAM aware spin-up

✔ Idle emulator cleanup

📊 Observability

✔ Prometheus

✔ Grafana

✔ Metrics endpoints enabled

🎥 Test Artifacts

✔ scrcpy screen capture

✔ ffmpeg video recording

✔ Per-test video support

🌐 Network Simulation

✔ tc + netem

✔ 2G / 3G / 4G / 5G profiles

🔐 Security

✔ UFW firewall hardening

✔ Appium localhost-only binding

✔ No USB passthrough

✔ Reboot-safe services enabled

⚡ One-Click Install
📄 Script Location
install-device-farm.sh

▶️ Run Installation
sudo bash install-device-farm.sh


⏱️ Typical install time: 10–15 minutes
📜 Full logs: /var/log/devicefarm-install.log

🧪 Verify Installation (2 Minutes)

After installation completes, run the following checks:

# Verify Appium drivers
appium driver list

# Verify emulator / device visibility
adb devices

# Check Appium service
systemctl status appium

# Check emulator auto-scaler
systemctl status emulator-scaler.timer


Expected results:

Appium drivers listed (uiautomator2, espresso)

At least one emulator visible via ADB

All services in active (running) state

✅ Result

After successful installation, you have:

✅ An internal Firebase Test Lab alternative

✅ Unlimited Android test execution

✅ CI/CD-ready Appium Grid

✅ Emulator auto-scaling

✅ Network condition testing

✅ Video recordings per test

✅ Metrics & dashboards

✅ Fully self-hosted & secure
