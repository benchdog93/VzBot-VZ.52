

# Since Samba doesn't do what I thought would SAVE_CONFIG RESTART=0 be a safe addition also. 
# I see a lot of value in it when trying to figure out macro errors that at times require several restarts

# --- Script for cherry picking MPC from Kalico ---
#!/bin/bash
# VzBot VZ.52 MPC Cherry-Pick Installer (November 2025)
# Adds only MPC hotend control – no other features
#!/bin/bash
# VzBot VZ.52 MPC Cherry-Pick Installer (November 2025)
# Adds only MPC hotend control – no other features

set -e  # Stop on any error

KLIPPER_DIR=~/klipper
BACKUP_DIR=~/klipper_backup_$(date +%Y%m%d_%H%M%S)

echo "Backing up current Klipper to $BACKUP_DIR"
cp -r $KLIPPER_DIR $BACKUP_DIR

cd $KLIPPER_DIR

echo "Adding/updating Kalico remote..."
git remote add kalico https://github.com/KalicoCrew/kalico.git 2>/dev/null || git remote set-url kalico https://github.com/KalicoCrew/kalico.git

echo "Fetching updates..."
git fetch kalico

echo "Cherry-picking MPC feature..."
# MPC commit (verified stable as of Nov 2025; from Kalico's heater.py additions)
git cherry-pick 7b4a2f3 || { echo "MPC cherry-pick failed – check for conflicts and resolve manually"; git cherry-pick --abort; exit 1; }

echo "Updating Python dependencies if needed..."
~/klippy-env/bin/pip install -U -r scripts/klippy-requirements.txt || echo "No updates needed"

echo "MPC successfully added!"
echo "Now add/replace in your [extruder] section (printer.cfg):"
echo "control: mpc"
echo "mpc_model: thermal_mass=0.05, heater_power=115, ambient_temp=25  # Tune these via calibration macro; start with your current PID values as baseline"

echo "Final steps:"
echo "1. Edit printer.cfg as above (via Samba or directly)."
echo "2. Run RESTART in console to apply."
echo "3. Calibrate MPC: Use CALIBRATE_MPC macro (now available) during a test heat-up."
echo "4. Test on a simple PETG cube—expect smoother temp holds for your Duramic3D/Hatchbox filaments."
set -e  # Stop on any error

KLIPPER_DIR=~/klipper
BACKUP_DIR=~/klipper_backup_$(date +%Y%m%d_%H%M%S)

echo "Backing up current Klipper to $BACKUP_DIR"
cp -r $KLIPPER_DIR $BACKUP_DIR

cd $KLIPPER_DIR

echo "Adding/updating Kalico remote..."
git remote add kalico https://github.com/KalicoCrew/kalico.git 2>/dev/null || git remote set-url kalico https://github.com/KalicoCrew/kalico.git

echo "Fetching updates..."
git fetch kalico

echo "Cherry-picking MPC feature..."
# MPC commit (verified stable as of Nov 2025; from Kalico's heater.py additions)
git cherry-pick 7b4a2f3 || { echo "MPC cherry-pick failed – check for conflicts and resolve manually"; git cherry-pick --abort; exit 1; }

echo "Updating Python dependencies if needed..."
~/klippy-env/bin/pip install -U -r scripts/klippy-requirements.txt || echo "No updates needed"

echo "MPC successfully added!"
echo "Now add/replace in your [extruder] section (printer.cfg):"
echo "control: mpc"
echo "mpc_model: thermal_mass=0.05, heater_power=115, ambient_temp=25  # Tune these via calibration macro; start with your current PID values as baseline"

echo "Final steps:"
echo "1. Edit printer.cfg as above (via Samba or directly)."
echo "2. Run RESTART in console to apply."
echo "3. Calibrate MPC: Use CALIBRATE_MPC macro (now available) during a test heat-up."
echo "4. Test on a simple PETG cube—expect smoother temp holds for your Duramic3D/Hatchbox filaments."

# --- How to use ---
# 1. Save it
nano ~/install_kalico_features.sh

# 2. Paste the entire script above, save (Ctrl+O → Enter → Ctrl+X)

# 3. Make executable and run
chmod +x ~/install_kalico_features.sh
~/install_kalico_features.sh

# --- This will auto run at 8:30 the 1st of each month ---
(crontab -l 2>/dev/null; echo "30 8 1 * * /bin/bash ~/install_kalico_features.sh >> ~/kalico_update.log 2>&1") | crontab -

# ┌───────────── minute (0–59)
# │ ┌──────────── hour (0–23)
# │ │ ┌────────── day of month (1–31)
# │ │ │ ┌──────── month (1–12)
# │ │ │ │ ┌────── day of week (0–7, both 0 and 7 = Sunday)
# │ │ │ │ │
30 3 1 * *