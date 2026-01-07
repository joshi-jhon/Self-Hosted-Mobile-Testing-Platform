#!/usr/bin/env bash
set -euo pipefail

########################################
# GLOBALS
########################################
LOG="/var/log/devicefarm-install.log"
ANDROID_USER="android"
ANDROID_HOME="/opt/android-sdk"
APPPIUM_DIR="/opt/appium"
DEVICEFARMER_DIR="/opt/devicefarmer"
EMULATOR_AVD="Pixel_API_33"
MAX_EMULATORS=10

exec > >(tee -a "$LOG") 2>&1

########################################
# HELPERS
########################################
err() { echo "[ERROR] $1"; exit 1; }
ok()  { echo "[OK] $1"; }
run() { "$@" || err "Failed: $*"; }

require_root() {
  [[ $EUID -eq 0 ]] || err "Run as root"
}

########################################
# PRECHECKS
########################################
require_root
ok "Running as root"

lsb_release -a | grep -q "22.04" || err "Ubuntu 22.04 required"

########################################
# SYSTEM PACKAGES
########################################
ok "Installing base packages"
run apt update
run apt install -y \
  openjdk-17-jdk \
  curl wget unzip git \
  adb \
  ffmpeg \
  scrcpy \
  tcptraceroute \
  net-tools \
  ufw \
  nodejs npm \
  python3 python3-pip

########################################
# NON-ROOT ANDROID USER
########################################
if ! id "$ANDROID_USER" &>/dev/null; then
  run useradd -m -s /bin/bash "$ANDROID_USER"
fi
ok "Android user ready"

########################################
# ANDROID SDK
########################################
if [[ ! -d "$ANDROID_HOME" ]]; then
  ok "Installing Android SDK"
  mkdir -p "$ANDROID_HOME"
  cd /tmp
  run wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
  run unzip commandlinetools-linux-*.zip
  mv cmdline-tools "$ANDROID_HOME/"
fi

export ANDROID_HOME
export PATH="$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

yes | "$ANDROID_HOME"/cmdline-tools/bin/sdkmanager --licenses

sdkmanager \
  "platform-tools" \
  "platforms;android-33" \
  "emulator" \
  "system-images;android-33;google_apis;x86_64"

########################################
# AVD
########################################
if ! sudo -u "$ANDROID_USER" avdmanager list avd | grep -q "$EMULATOR_AVD"; then
  sudo -u "$ANDROID_USER" echo "no" | \
    avdmanager create avd \
      -n "$EMULATOR_AVD" \
      -k "system-images;android-33;google_apis;x86_64"
fi
ok "AVD ready"

########################################
# DEVICEFARMER
########################################
if [[ ! -d "$DEVICEFARMER_DIR" ]]; then
  ok "Installing DeviceFarmer"
  run git clone https://github.com/DeviceFarmer/stf.git "$DEVICEFARMER_DIR"
  cd "$DEVICEFARMER_DIR"
  run npm install
fi

########################################
# APPIUM 2
########################################
ok "Installing Appium 2"
run npm install -g appium@2
run appium driver install uiautomator2
run appium driver install espresso

########################################
# APPIUM CONFIG
########################################
mkdir -p "$APPPIUM_DIR"
cat > "$APPPIUM_DIR/appium.yaml" <<EOF
server:
  address: 127.0.0.1
  port: 4723
  use-drivers:
    - uiautomator2
    - espresso
drivers:
  uiautomator2:
    automationName: UiAutomator2
    platformName: Android
EOF

########################################
# APPIUM SYSTEMD
########################################
cat > /etc/systemd/system/appium.service <<EOF
[Unit]
Description=Appium 2 Server
After=network.target

[Service]
ExecStart=/usr/bin/appium --config $APPPIUM_DIR/appium.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF

########################################
# EMULATOR AUTO-SCALER
########################################
cat > /usr/local/bin/emulator-scaler.sh <<'EOF'
#!/bin/bash
MAX=10
RUNNING=$(adb devices | grep emulator | wc -l)
if [ "$RUNNING" -lt "$MAX" ]; then
  sudo -u android emulator -avd Pixel_API_33 \
    -no-snapshot -no-window -gpu swiftshader_indirect &
fi
EOF
chmod +x /usr/local/bin/emulator-scaler.sh

cat > /etc/systemd/system/emulator-scaler.timer <<EOF
[Timer]
OnBootSec=2min
OnUnitActiveSec=30s
EOF

cat > /etc/systemd/system/emulator-scaler.service <<EOF
[Service]
ExecStart=/usr/local/bin/emulator-scaler.sh
EOF

########################################
# PROMETHEUS + GRAFANA
########################################
ok "Installing Prometheus + Grafana"
run apt install -y prometheus grafana
systemctl enable grafana-server prometheus

########################################
# NETWORK SHAPING PROFILES
########################################
cat > /usr/local/bin/netem-profile.sh <<EOF
#!/bin/bash
tc qdisc del dev eth0 root 2>/dev/null
case "\$1" in
  2G) tc qdisc add dev eth0 root netem delay 800ms loss 10% ;;
  3G) tc qdisc add dev eth0 root netem delay 300ms loss 3% ;;
  4G) tc qdisc add dev eth0 root netem delay 80ms ;;
  5G) tc qdisc add dev eth0 root netem delay 20ms ;;
esac
EOF
chmod +x /usr/local/bin/netem-profile.sh

########################################
# FIREWALL
########################################
ufw allow 443
ufw allow 7100
ufw allow ssh
ufw --force enable

########################################
# ENABLE SERVICES
########################################
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now appium
systemctl enable --now emulator-scaler.timer

########################################
# DONE
########################################
ok "=================================================="
ok " DEVICE FARM INSTALLED SUCCESSFULLY"
ok " Appium        : http://127.0.0.1:4723"
ok " DeviceFarmer  : reverse proxy via NPM"
ok " Grafana       : http://<host>:3000"
ok " Logs          : $LOG"
ok "=================================================="
