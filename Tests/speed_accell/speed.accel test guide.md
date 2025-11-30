
# My VzBot Vz.52 Limited CoreXY – Speed & Acceleration Testing Guide

## Purpose

This document outlines a safe, systematic process to test speed and acceleration limits on a Limited CoreXY kinematics. The goal is to determine the maximum stable speed and acceleration for X, Y, and diagonal movements without skipping steps, causing vibration, or damaging the printer.


## **Method 1 – Manual Limited CoreXY Speed Test (standard macros)**

## Required Macros

Before running any tests, ensure the following macros are defined in your Klipper configuration:

* `TEST_SPEED` – Full XY pattern test.
* `TEST_AXIS_SPEED` – Tests X and Y axes independently.
* `TEST_CARDINAL_SPEED` – Cardinal (X/Y) movement test.
* `TEST_DIAG_SPEED` – Diagonal movement test.
* `TEST_X_SPEED` – X-axis only test.
* `TEST_Y_SPEED` – Y-axis only test.

> These macros handle homing, G-code state saving/restoring, velocity and acceleration limits, and defined motion patterns.

## Preparation

1. **Mechanical Checks**

   * Belts tensioned and aligned.
   * Pulleys secure.
   * Rails clean and lubricated.
   * No loose screws, cables, or obstructions in the path.

2. **Firmware Verification**

   * Confirm `limited_corexy` kinematics is active in Klipper.
   * Ensure `max_velocity`, `max_accel`, and `max_accel_to_decel` reflect safe starting limits.

3. **Test Parameters**

   * Starting Z height (`ZPOS`) = 10 mm.
   * Bounding inset (`BOUND`) = 30 mm to prevent collisions with the frame.
   * Iterations per test = 1–2.

## Testing Process

### Step 1: Baseline Test

* Start at a low speed and acceleration (e.g., 100 mm/s, 1000 mm/s²) using `TEST_SPEED`.
* Observe for skipped steps, ringing, or unusual vibrations.

### Step 2: Incremental Speed Increase

* Increase speed gradually (e.g., +50 mm/s per step) while keeping acceleration low.
* After each test, inspect motion quality and mechanical stability.

### Step 3: Incremental Acceleration Increase

* Once a safe speed is determined, increase acceleration in steps (e.g., +500 mm/s²).
* Use `TEST_AXIS_SPEED` to test X and Y independently, identifying differences in motor performance.

### Step 4: Pattern Evaluation

* **Full XY pattern (`TEST_SPEED`)** – stresses combined X and Y axes.
* **Small/centered boxes** – tests cornering and small movements.
* **Diagonal (`TEST_DIAG_SPEED`)** – evaluates combined axis motion, important for CoreXY geometry.
* **Cardinal moves (`TEST_CARDINAL_SPEED`)** – simple X/Y movements for comparison.
* **Single-axis tests (`TEST_X_SPEED` / `TEST_Y_SPEED`)** – isolate axis-specific limits.

### Step 5: Pausing & Inspection

* Pause after each test step to check:

  * Stepper skipping
  * Vibrations or ringing
  * Belt tension and pulleys
* Adjust speed/acceleration values before proceeding if needed.

### Step 6: Document Safe Limits

* Record maximum stable speed and acceleration for:

  * X-axis only
  * Y-axis only
  * Combined diagonal movements
* Note any differences due to motor torque, belt tension, or mechanical characteristics.

## Safety Notes

* Start conservative; diagonal moves produce higher effective velocities.
* Pause frequently for inspection.
* Only increase parameters if the previous test was stable.
* Keep iterations low initially (1–2).
* Restore firmware max velocity and acceleration limits after testing.

## Recommended Workflow Example

1. `TEST_SPEED` at low speed/accel → pause → inspect.
2. Increment speed → run `TEST_SPEED` → pause → inspect.
3. Increment acceleration → run `TEST_AXIS_SPEED` → pause → inspect.
4. Run `TEST_DIAG_SPEED` → pause → inspect.
5. Run `TEST_CARDINAL_SPEED` → pause → inspect.
6. Run `TEST_X_SPEED` / `TEST_Y_SPEED` → pause → inspect.
7. Document safe parameters.
8. Repeat incrementally until maximum stable limits are found.

---

## **Method 2 – Automated CoreXY Speed/Acceleration Test Script (corexy_speed_test.txt)**

## The same Required Macros and Preparation as Required in Method 1

This method uses the standalone script file:

**corexy_speed_test.gcode**

## User Configurable Parameters within corexy_speed_test.txt

## You can use this as is or set the test parameters to your specific needs
## After any if edits place corexy_speed_test.gcode in your /home/pi/printer_data/gcodes/


## USER CONFIGURABLE PARAMETERS

; ---------------- Speed Parameters ----------------
* {% set SET_START_SPEED = 500 %}       ; Starting speed for tests (mm/s)
* {% set SET_MAX_SPEED = 900 %}         ; Maximum speed for tests (mm/s)
* {% set SET_SPEED_STEP = 50 %}         ; Increment per test (mm/s)

; ---------------- Acceleration Parameters ----------------
* You can set X and Y accelerations independently to test Limited CoreXY kinematics
* {% set SET_START_X_ACCEL = 1000 %}    ; Starting X acceleration (mm/s^2)
* {% set SET_MAX_X_ACCEL = 5000 %}      ; Maximum X acceleration (mm/s^2)
* {% set SET_X_ACCEL_STEP = 500 %}      ; Increment for X acceleration (mm/s^2)

* {% set SET_START_Y_ACCEL = 1000 %}    ; Starting Y acceleration (mm/s^2)
* {% set SET_MAX_Y_ACCEL = 5000 %}      ; Maximum Y acceleration (mm/s^2)
* {% set SET_Y_ACCEL_STEP = 500 %}      ; Increment for Y acceleration (mm/s^2)

; ---------------- Test Control Parameters ----------------
* {% set SET_ITERATIONS = 1 %}          ; Number of times to repeat each test pattern
* {% set SET_ZPOS = 10 %}               ; Z height for test moves (mm)
* {% set SET_BOUND = 30 %}              ; Bounding inset to prevent collisions (mm)
Run the script at any time from the console:

### **How to Run It (Fluidd/Mainsail Console)**

### RUN_GCODE_FILE FILE=corexy_speed_gcode.gcode

This will automatically:

* home the printer
* run all movement patterns
* step through speeds and acceleration levels
* pause between sequences
* restore velocity limits at the end

### **Important Notes**

* This document provides a **safe, repeatable procedure** to determine the operating limits of your Limited 
    CoreXY printer. Following this process ensures you can safely optimize speed and acceleration without damaging 
    the printer or compromising print quality
* Do **not** run this on a printer with mechanical issues.
* Ensure your bounding inset (`BOUND`) and Z position (`ZPOS`) are safe.
* The script respects your Klipper velocity limits and restores them afterward.

---
