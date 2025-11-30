
# VzBot AWD Triple-Z (Limited CoreXY)

# Skew Calibration Procedure for Klipper

---

## 1. Required Calibration STL

Use the official **Klipper XY Skew Calibration Square (100mm x 100mm)**. Search for:
**"Klipper XY Skew Calibration STL calibrate_xy_square.stl"**
on the Klipper GitHub in the `docs/prints/` folder.

---

## 2. Print Settings

* Model size: **100 mm × 100 mm**
* Height: **6–8 mm**
* Perimeters: **3–4**
* Infill: **20–40%**
* Material: **PLA recommended**
* Cooling: Normal
* Speed: Normal VzBot print speed
* Bed placement: Center of the bed (330×330)

---

## 3. Required Measurements

After printing, measure using digital calipers:

1. **X dimension** (left–right) — target ~100 mm
2. **Y dimension** (front–back) — target ~100 mm
3. **Diagonal AC** (top-left → bottom-right)
4. **Diagonal BD** (top-right → bottom-left)

Tips:

* Do not squeeze the calipers; measure lightly.
* Ensure measurements are taken from the same height on all sides.

---

## 4. Provide Measurements for Calculation

```
X =
Y =
AC =
BD =
```

## 8. Built-In Klipper Skew Calculator

Klipper includes its own skew calculation tools. After measuring your printed calibration square, run the following in your Klipper console:

### **A. Run the Skew Calculation**

```
SKEW_CALCULATION AC=<value> BD=<value> X=<value> Y=<value>
```

Example:

```
SKEW_CALCULATION AC=141.52 BD=142.07 X=100.11 Y=99.98
```

Klipper will output:

```
xy_skew = <calculated_value>
xz_skew = 0.0
yz_skew = 0.0
```

Paste these results into your `printer.cfg` under `[skew_correction]`.

---

## 5. Applying Skew Correction in Klipper

Once you receive your numbers, add the section to your `printer.cfg`:

```
[skew_correction]
xy_skew = <calculated_value>
xz_skew = 0
yz_skew = 0
```

Save the file and run:

```
RESTART
```

(Optional) Verify using:

```
SKEW_PROFILE_CHECK
```

---

## 6. Verification

Print the **same 100 mm calibration square** again.
Your results should now show:

* Diagonals within **0.05 mm** of each other
* X/Y dimensions close to perfect

If still off:

1. Re-measure
2. Recalculate
3. Update the `[skew_correction]` value

---

## 7. Notes for VzBot AWD Triple-Z

* CoreXY printers typically require **only XY skew** correction.
* AWD frames are stiff, so skew corrections are small but valuable.
* Triple-Z maintains squareness extremely well; calibration is usually stable over time.

---



### **B. Validate the Skew Profile**

```
SKEW_PROFILE_CHECK
```

This confirms the skew values are physically valid.

### **C. Optional: Test Skew Without Editing Config**

```
SET_SKEW xy=<value>
```

This applies skew correction temporarily for testing.

---

## Summary

This file contains:

* The STL to use
* How to print it
* How to measure it
* What data to collect
* How to apply skew correction
* How to verify accuracy

You only need to input measurements to get your exact correction value.
