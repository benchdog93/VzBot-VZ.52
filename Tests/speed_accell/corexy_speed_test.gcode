;====================================================
; VZ-Bot Vz.52 Limited CoreXY SAFE Speed & Acceleration Test
;====================================================
; Required Macros (must be defined in printer config):
; - TEST_SPEED
; - TEST_AXIS_SPEED
; - TEST_CARDINAL_SPEED
; - TEST_DIAG_SPEED
; - TEST_X_SPEED
; - TEST_Y_SPEED
;====================================================

#=========================================
# USER CONFIGURABLE PARAMETERS
#=========================================
; ---------------- Speed Parameters ----------------
{% set SET_START_SPEED = 500 %}       ; Starting speed for tests (mm/s)
{% set SET_MAX_SPEED = 900 %}         ; Maximum speed for tests (mm/s)
{% set SET_SPEED_STEP = 50 %}         ; Increment per test (mm/s)

; ---------------- Acceleration Parameters ----------------
; You can set X and Y accelerations independently to test Limited CoreXY kinematics
{% set SET_START_X_ACCEL = 1000 %}    ; Starting X acceleration (mm/s^2)
{% set SET_MAX_X_ACCEL = 5000 %}      ; Maximum X acceleration (mm/s^2)
{% set SET_X_ACCEL_STEP = 500 %}      ; Increment for X acceleration (mm/s^2)

{% set SET_START_Y_ACCEL = 1000 %}    ; Starting Y acceleration (mm/s^2)
{% set SET_MAX_Y_ACCEL = 5000 %}      ; Maximum Y acceleration (mm/s^2)
{% set SET_Y_ACCEL_STEP = 500 %}      ; Increment for Y acceleration (mm/s^2)

; ---------------- Test Control Parameters ----------------
{% set SET_ITERATIONS = 1 %}          ; Number of times to repeat each test pattern
{% set SET_ZPOS = 10 %}               ; Z height for test moves (mm)
{% set SET_BOUND = 30 %}              ; Bounding inset to prevent collisions (mm)

#=========================================
# INITIAL SETUP
#=========================================
G28
M117 Starting CoreXY SAFE Speed/Accel Test
SAVE_GCODE_STATE NAME=TEST_SPEED_AUTOMATION
G90

#=========================================
# MAIN TEST LOOP
#=========================================
{% set speed = SET_START_SPEED %}
{% while speed <= SET_MAX_SPEED %}

  {% set x_accel = SET_START_X_ACCEL %}
  {% while x_accel <= SET_MAX_X_ACCEL %}

    {% set y_accel = SET_START_Y_ACCEL %}
    {% while y_accel <= SET_MAX_Y_ACCEL %}

      M117 Testing SPEED={speed} X_ACCEL={x_accel} Y_ACCEL={y_accel}

      ;--- Full XY Pattern ---
      TEST_SPEED SPEED={speed} ACCEL={x_accel} ITERATIONS={SET_ITERATIONS} ZPOS={SET_ZPOS} BOUND={SET_BOUND}
      M117 Completed TEST_SPEED at SPEED={speed} X_ACCEL={x_accel} Y_ACCEL={y_accel}
      PAUSE

      ;--- Axis-Specific Pattern ---
      TEST_AXIS_SPEED SPEED={speed} X_ACCEL={x_accel} Y_ACCEL={y_accel} ITERATIONS={SET_ITERATIONS} ZPOS={SET_ZPOS} BOUND={SET_BOUND}
      M117 Completed TEST_AXIS_SPEED at SPEED={speed} X_ACCEL={x_accel} Y_ACCEL={y_accel}
      PAUSE

      ;--- Cardinal Directions ---
      TEST_CARDINAL_SPEED SPEED={speed} ACCEL={x_accel} ITERATIONS={SET_ITERATIONS} ZPOS={SET_ZPOS} BOUND={SET_BOUND}
      M117 Completed TEST_CARDINAL_SPEED at SPEED={speed} X_ACCEL={x_accel} Y_ACCEL={y_accel}
      PAUSE

      ;--- Diagonal Movement ---
      TEST_DIAG_SPEED SPEED={speed} ACCEL={x_accel} ITERATIONS={SET_ITERATIONS} ZPOS={SET_ZPOS} BOUND={SET_BOUND}
      M117 Completed TEST_DIAG_SPEED at SPEED={speed} X_ACCEL={x_accel} Y_ACCEL={y_accel}
      PAUSE

      ;--- Single Axis Tests ---
      TEST_X_SPEED SPEED={speed} ACCEL={x_accel} ITERATIONS={SET_ITERATIONS} ZPOS={SET_ZPOS} BOUND={SET_BOUND}
      M117 Completed TEST_X_SPEED at SPEED={speed} X_ACCEL={x_accel} Y_ACCEL={y_accel}
      PAUSE

      TEST_Y_SPEED SPEED={speed} ACCEL={y_accel} ITERATIONS={SET_ITERATIONS} ZPOS={SET_ZPOS} BOUND={SET_BOUND}
      M117 Completed TEST_Y_SPEED at SPEED={speed} X_ACCEL={x_accel} Y_ACCEL={y_accel}
      PAUSE

      {% set y_accel = y_accel + SET_Y_ACCEL_STEP %}
    {% endwhile %}

    {% set x_accel = x_accel + SET_X_ACCEL_STEP %}
  {% endwhile %}

  {% set speed = speed + SET_SPEED_STEP %}
{% endwhile %}

#=========================================
# RESTORE PRINTER STATE
#=========================================
SET_VELOCITY_LIMIT VELOCITY={printer.configfile.settings.printer.max_velocity} ACCEL={printer.configfile.settings.printer.max_accel} ACCEL_TO_DECEL={printer.configfile.settings.printer.max_accel_to_decel}
RESTORE_GCODE_STATE NAME=TEST_SPEED_AUTOMATION
M117 CoreXY SAFE Speed/Accel Test Complete
