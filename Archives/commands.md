
# --- git push commands ---
cd ~
cp -r ~/printer_data/config/* ~/VzBot-VZ.52/        # overwrites everything
cd ~/VzBot-VZ.52
git add .
git commit -m "update $(date +"%Y-%m-%d %H:%M")"
git push

cd ~/VzBot-VZ.52 && git pull

cd ~/VzBot-VZ.52 && git fetch && git reset --hard origin/main && git pull

vzup

# Clone the VzBot configuration repository
git clone https://github.com/benchdog93/VzBot-VZ.52.git ~/VzBot-VZ.52

echo "Configuration pulled successfully to ~/VzBot-VZ.52. For reference, your VzBot setup is at https://github.com/benchdog93/VzBot-VZ.52."

# --- Test Speed/Accellaration ---
RUN_GCODE_FILE FILE=corexy_speed_gcode.gcode

# --- RPi commands ---
sudo raspi-config
sudo reboot
sudo halt
sudo poweroff
sudo shutdown -h now
sudo shutdown -h 10 # in 10 minutes
sudo init 0
vcgencmd get_camera
sudo i2cdetect -y 1
 
lsusb
./scripts/uninstall.sh
rm -rf ~/beacon
./kiauh/kiauh.sh

# --- Tradrak Commands ---
set_active_spool ID=T0
TR_HOME
TR_GO_TO_LANE
TR_LOAD_LANE
TR_LOAD_TOOLHEAD
T0, T1, T2, etc.
TR_UNLOAD_TOOLHEAD
TR_SERVO_DOWN
TR_SERVO_UP
TR_SET_ACTIVE_LANE
TR_RESET_ACTIVE_LANE
TR_RESUME
TR_LOCATE_SELECTOR
TR_NEXT
TR_SYNC_TO_EXTRUDER
TR_UNSYNC_FROM_EXTRUDER
# --- Calibration and testing ---
TR_SERVO_TEST
TR_CALIBRATE_SELECTOR
TR_SET_HOTEND_LOAD_LENGTH
# --- Tool mapping --- 
TR_SET_DEFAULT_LANE
TR_RESET_TOOL_MAP
TR_PRINT_TOOL_MAP
TR_PRINT_TOOL_GROUPS
TR_ASSIGN_LANE LANE=10 TOOL=0 SET_DEFAULT=10

# --- Beacon commands ---
BEACON_CALIBRATE
TESTZ Z=-0.01
BEACON_QUERY
PROBE_ACCURACY 
BEACON_ESTIMATE_BACKLASH
VZ_BEACON_CALIBATE

# --- Spoolman Commands ---
SET_ACTIVE_SPOOL ID=1
clear_active_spool

# --- Commands ---
BELTS_SHAPER_CALIBRATION    #for belt resonance graphs, useful for verifying belt tension and differential belt paths behavior.
COMPARE_BELTS_RESPONSES     #Generate a differential belt resonance graph to verify relative belt tensions and belt path behaviors on a CoreXY 
AXES_SHAPER_CALIBRATION     #for input shaper graphs to mitigate ringing/ghosting by tuning Klipper's input shaper system.
AXES_MAP_CALIBRATION        #Verify that your accelerometer is working correctly and automatically find its Klipper's axes_map parameter
VIBRATIONS_CALIBRATION      #for machine vibration graphs to optimize your slicer speed profiles.
CREATE_VIBRATIONS_PROFILE
EXCITATE_AXIS_AT_FREQ       #to sustain a specific excitation frequency, useful to let you inspect and find out what is resonating.

# --- Accelermeter ---
ACCELEROMETER_QUERY
MEASURE_AXES_NOISE
HOLD_RESONANCE AXIS=<axis> FREQ=int SECONDS=<seconds>

# --- Bed Mesh Commands ---
BED_MESH_CLEAR

# --- Steppers ---
DUMP_TMC STEPPER=stepper_x
STEPPER_BUZZ STEPPER=stepper_x

# --- Skew ---
SET_SKEW XY=140.4,142.8,99.8
SKEW_PROFILE SAVE=my_skew_profile
SKEW_PROFILE LOAD=my_skew_profile
SKEW_PROFILE REMOVE=my_skew_profile
GET_CURRENT_SKEWSET_SKEW
SKEW_PROFILE
SET_SKEW CLEAR=1
CALC_MEASURED_SKEW AC=<ac_length> BD=<bd_length> AD=<ad_length>

SET_SKEW XY=140.65,141.46,99.7 XZ=141.0,140.69,99.83 YZ=140.61,140.95,99.79

SET_GCODE_OFFSET Z=0 

# --- Extruder Calibration ---
M302 P1 (allows cold extrusion)

M83 ; E relative
G1 E1 F60 ; Extrude 1mm at 1mm/s (60mm/min)

M83 ; E relative
G1 E100 F60 ; Extrude 100mm at 1mm/s (60mm/min)

Calculate your new rotation_distance using this formula:

    <new_rotation_distance> = <previous_rotation_distance> * ( <actual_extrude_distance> / 100 )

# --- Flow Calulation ---
layer_width * layer_height * speed = flow
or
speed = flow/(layer_width * layer_height)

# --- Additional RPi commands ----
sudo systemctl restart KlipperScreen
dfu-util -a 0 -D ~/katapult/out/deployer.bin -s 0x08000000:leave
sudo apt install dfu-util
sudo usermod -a -G dialout $USER   # add yourself to the right group (one time)
sudo usermod -a -G plugdev $USER   # also helpful on some systems
lsusb | grep 0483
sudo dfu-util -a 0 -D ~/klipper/out/klipper.bin -s 0x08000000:leave

sudo dfu-util -a 0 -D ~/katapult/out/deployer.bin -s 0x08000000:mass-erase:force:leave
sudo dfu-util -a 0 -D ~/katapult/Fly-Super8Pro-H723-Bootloader.bin -s 0x08000000:mass-erase:force:leave

#==================================
# Python Scripts
#==================================

C:\Users\Ed\AppData\Local\Programs\Python\Python310\python.exe
C:\Users\Ed\AppData\Local\Programs\Python\Python310\Scripts\accelerations.py
C:\python-3.10.11\python.exe 
C:\python-3.10.11\scripts\perAxis.py;
C:\Klipper Estimator\scripts\KlipperEstimator.py
C:\KlipperEstimator\klipper_estimator.exe --config_moonraker_url http://192.168.1.5 post-process;


#======================================================
# Return Klipper to previous version if ever needed
#======================================================

cd ~/klipper
sudo systemctl stop klipper
git reset --hard g3fe594ef 
sudo systemctl start klipper
