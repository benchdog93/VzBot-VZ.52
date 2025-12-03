

=================================================================
## Always check for and install the latest recommended versions
=================================================================

# Raspberry Pi + Klipper + VzBot / TradRack Full Install Guide

A simplified, organized, and easy-to-follow version of my entire installation workflow.

---

# **1. Install Raspberry Pi Operating System**

### Download & Flash

1. Download **Debian Bookworm OS Lite (Legacy 64-bit)**.
2. Flash it to your SD card using Raspberry Pi Imager.

---

# **2. Initial Raspberry Pi Setup**

### Update the system

```
sudo apt update && sudo apt upgrade -y
```

### Install Git

```
sudo apt install git -y
```

### Install Libcamera

```
sudo apt install libcamera-apps-lite -y
```

### Install Python tools

```
sudo apt update && sudo apt full-upgrade -y
sudo apt install git curl python3-venv -y
```

---

# **3. Enable Interfaces (SPI & I2C)**

Run:

```
sudo raspi-config
```

Then enable **SPI** and **I2C** under *Interfacing Options*.

---

# **4. Install Linux GPIO Character Device Tools**

```
sudo apt install gpiod -y
gpiodetect
gpioinfo
```

---

# **5. Enable PWM Output**

Add overlays to `/boot/firmware/config.txt`:

```
dtoverlay=pwm,pin=12,func=4
dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4
```

Export channels:

```
echo 0 | sudo tee /sys/class/pwm/pwmchip0/export
echo 1 | sudo tee /sys/class/pwm/pwmchip0/export
```

PWM routing reference:

```
PWM | GPIO | Function
0   | 12   | 4
0   | 18   | 2
1   | 13   | 4
1   | 19   | 2
```

---

# **6. Samba Installation**

## Create file `install_samba_gw.sh`: 'replace gw with your pi user name here and in all the places gw appears in the below script' 

```
#!/bin/bash
set -e

SHARE_PATH="/home/gw"
SMB_CONF="/etc/samba/smb.conf"
SERVICE_DIR="/etc/systemd/system/smbd.service.d"

echo "=== Installing Samba ==="
sudo apt update
sudo apt install -y samba samba-common-bin

echo "=== Setting permissions for /home/gw ==="
sudo chmod 755 /home/gw
sudo chown -R gw:gw /home/gw

echo "=== Removing old gw_home share if present ==="
sudo sed -i "/\\[gw_home\\]/,/^\\s*$/d" "$SMB_CONF"

echo "=== Adding new Samba share block ==="
sudo tee -a "$SMB_CONF" >/dev/null <<EOF

[gw_home]
   comment = Home folder for gw
   path = /home/gw
   browseable = yes
   writable = yes
   valid users = gw
   force user = gw
   force group = gw
   create mask = 0664
   directory mask = 0775
   guest ok = no
EOF

echo "=== Creating Samba password for gw ==="
sudo smbpasswd -a gw

echo "=== Ensuring Samba starts AFTER filesystem and network ==="
sudo mkdir -p "$SERVICE_DIR"
sudo tee "$SERVICE_DIR/override.conf" >/dev/null <<EOF
[Unit]
After=network-online.target local-fs.target
Wants=network-online.target
EOF

echo "=== Reloading systemd and restarting Samba ==="
sudo systemctl daemon-reload
sudo systemctl restart smbd
sudo systemctl restart nmbd

echo ""
echo "====================================================="
echo " Samba installation completed successfully!"
echo " Share: \\\\$(hostname -I | awk '{print $1}')\\gw_home"
echo "====================================================="
```

Run script:

```
chmod +x install_samba_gw.sh
sudo ./install_samba_gw.sh
```

Windows mapping:

```
\\192.168.1.5\<your user name>
```

---

# **7. Install KIAUH**

```
git clone https://github.com/dw-0/kiauh.git
./kiauh/kiauh.sh
```

Install using the menu:

* Klipper
* Moonraker
* Fluidd
* KlipperScreen
* Crowsnest
* Gcode Shell Command
* Mobileraker

---

# **8. Install Klipper for RPi MCU**

```
cd ~/klipper/
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
```

### Configure

```
cd ~/klipper
make menuconfig
```

Set:

* Microcontroller Architecture → **Linux Process**

### Build

```
sudo service klipper stop
make flash
sudo service klipper start
```

If permission denied:

```
sudo usermod -a -G tty gw
```

---

# **9. Build Firmware for Controller Board Fly Super∞ Pro HV **

## 1.) First check for the boards id

```
ls /dev/serial/by-id/
```
Should see something simular:
/dev/serial/by-id/usb-Klipper_stm32h723xx_12345-if00

## 2) Compile the Klipper firmware
```
cd ~/klipper
rm -rf .config out
make menuconfig
```
Set:

* Extra low-level options → enabled
* Architecture → **STM32**
* Processor → **STM32H723**
* Bootloader → **128KiB**
* Crystal → **25 MHz**
* USB (PA11/PA12)

Exit and save:

## 3.) Build:
```
make
```
## 4:) Put the board in DFU mode and flash
```
lsusb | grep -i "0483:df11\|1209:beba"

make flash FLASH_DEVICE=0483:df11    # or 1209:beba if that’s what showed up

```
## 5:) Reboot and verify
* Disconnect from RPi and remove DFU jumper
* Wait 10 seconds connect board back to RPi
* Verify id
```
ls /dev/serial/by-id/
```
Should see something simular:
/dev/serial/by-id/usb-Klipper_stm32h723xx_300----------------------if00
* Add to Printer config file:
  [mcu]
  serial:/dev/serial/by-id/usb-Klipper_stm32h723xx_300----------------------if00

# **10. TradRack Setup**

```
cd ~
curl -LJO https://raw.githubusercontent.com/Annex-Engineering/TradRack/main/Kalico/klippy_module/install.sh
chmod +x install.sh
./install.sh
rm install.sh
sudo systemctl restart klipper
```

### Moonraker Update Manager

```
[update_manager trad_rack]
type: git_repo
path: ~/trad_rack_klippy_module
origin: https://github.com/Annex-Engineering/TradRack.git
primary_branch: main
managed_services: klipper
```

---

# **11. Beacon Setup**

```
cd ~
git clone https://github.com/beacon3d/beacon_klipper.git
./beacon_klipper/install.sh
```

[update_manager beacon]
type: git_repo
channel: dev
path: ~/beacon_klipper
origin: https://github.com/beacon3d/beacon_klipper.git
env: ~/klippy-env/bin/python
requirements: requirements.txt
install_script: install.sh
is_system_service: False
managed_services: klipper
info_tags:
  desc=Beacon Surface Scanner

---

# **12. Belay Setup**

```
cd ~
curl -LJO https://raw.githubusercontent.com/Annex-Engineering/Belay/main/Kalico/klippy_module/install.sh
chmod +x install.sh
./install.sh
rm install.sh
sudo systemctl restart klipper
```

[update_manager belay]
type: git_repo
path: ~/belay_klippy_module
origin: https://github.com/Annex-Engineering/Belay.git
primary_branch: main
managed_services: klipper

---

# **13. Timelapse Setup**

```
cd ~
git clone https://github.com/mainsail-crew/moonraker-timelapse.git
cd moonraker-timelapse
./install.sh
```

[update_manager timelapse]
type: git_repo
primary_branch: main
path: ~/moonraker-timelapse
origin: https://github.com/mainsail-crew/moonraker-timelapse.git
managed_services: klipper moonraker

---

# **14. ResHelper Setup**

```
cd ~
git clone https://github.com/lhndo/ResHelper.git
cd ResHelper
./install.sh
```

---

# **15. Spoolman Installation**

Install:

```
sudo apt-get update && sudo apt-get install -y curl jq && \
mkdir -p ./Spoolman && \
source_url=$(curl -s https://api.github.com/repos/Donkie/Spoolman/releases/latest | jq -r '.assets[] | select(.name == "spoolman.zip").browser_download_url') && \
curl -sSL $source_url -o temp.zip && unzip temp.zip -d ./Spoolman && rm temp.zip && \
cd ./Spoolman && bash ./scripts/install.sh
```

Update:

```
sudo systemctl stop Spoolman
sudo systemctl disable Spoolman
systemctl --user stop Spoolman
systemctl --user disable Spoolman

mv Spoolman Spoolman_old && \
mkdir -p ./Spoolman && \
source_url=$(curl -s https://api.github.com/repos/Donkie/Spoolman/releases/latest | jq -r '.assets[] | select(.name == "spoolman.zip").browser_download_url') && \
curl -sSL $source_url -o temp.zip && unzip temp.zip -d ./Spoolman && rm temp.zip && \
cp Spoolman_old/.env Spoolman/.env && \
cd ./Spoolman && bash ./scripts/install.sh && \
rm -rf ../Spoolman_old
```

---

# **16. Per Axis Acceleration (kdb424)**

Download:

```
curl https://raw.githubusercontent.com/kdb424/klipper/peraxis-kdb/klippy/kinematics/limited_corexy.py --output ~/klipper/klippy/kinematics/limited_corexy.py
```

Required files:

* 'limited_corexy.py' run the curl above (from kdb424 blog) the file includes instructi0ons on how to set up in printer.cfg
* (portable) copy of Python3 for Windows (if using Windows)
* "embeddable package" from https://www.python.org/downloads/windows/
* 'perAxis.py' (from kdb424 blog) includes instructions on how to set up in slicer
* Place it here  C:\python-3.10.0\scripts\perAxis.py
* Place C:\python-3.10.11\python.exe C:\python-3.10.11\scripts\perAxis.py; in slicer post processing scripts
* Limited core xy slicer settings.txt 
