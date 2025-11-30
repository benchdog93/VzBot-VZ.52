
# Samba
* Connects my RPi to my Windows PC
* Allows me to edit in Microsoft VS vs. Fluidds built in editor
* Allows me to sync my live configuration to my GitHub repository

# ** Samba Installation Process**
## You will need to edit this and add your user name if not pi
## Create file `install_samba_pi.sh`: 'replace gw with your pi user name here and in all the places gw appears in the below script' 

```
#!/bin/bash
set -e

SHARE_PATH="/home/pi"
SMB_CONF="/etc/samba/smb.conf"
SERVICE_DIR="/etc/systemd/system/smbd.service.d"

echo "=== Installing Samba ==="
sudo apt update
sudo apt install -y samba samba-common-bin

echo "=== Setting permissions for /home/gw ==="
sudo chmod 755 /home/pi
sudo chown -R pi:pi /home/pi

echo "=== Removing old pi_home share if present ==="
sudo sed -i "/\\[pi_home\\]/,/^\\s*$/d" "$SMB_CONF"

echo "=== Adding new Samba share block ==="
sudo tee -a "$SMB_CONF" >/dev/null <<EOF

[gw_home]
   comment = Home folder for pi
   path = /home/pi
   browseable = yes
   writable = yes
   valid users = pi
   force user = pi
   force group = pi
   create mask = 0664
   directory mask = 0775
   guest ok = no
EOF

echo "=== Creating Samba password for pi ==="
sudo smbpasswd -a pi

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
echo " Share: \\\\$(hostname -I | awk '{print $1}')\\pi_home"
echo "====================================================="
```

Run script:

```
chmod +x install_samba_pi.sh
sudo ./install_samba_pi.sh
```

Windows mapping:

```
\\192.168.1....\<your user name>
```

---
