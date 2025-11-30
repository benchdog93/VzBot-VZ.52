
# =========================================
# My VzBot Vz.52 Limited CoreXY – Roadmap
# =========================================

# Printer Configuration:
    CPAP Flap Air Controler
    Cherry Pick Kalico

# Printer Tuning
    Trianglelab CHC Pro hotend + Micro Swiss CM2 0.4 nozzles 
    Trianglelab CHC Pro hotend + Micro Swiss CM2 0.6 nozzles 
    Trianglelab CHC XL hotends + Micro Swiss CM2 0.6 nozzles 

# Orca Slicer Profiles
    VzBot VZ.52 .4 nozzle MV
    VzBot VZ.52 .6 nozzle CHC Pro HV
    VzBot VZ.52 .6 nozzle CHC XL HV

# GitHub Updates
    Install Documentation
        Install.md
    
    Tests
        Speed/Accellaration
        Skew
    
    Tuning
        Automated Purge
# BOM
# STLs
# Printer Stats
    - performance
# Comparision Table
    - Add a small comparison table (size, cost, speed, complexity vs Vz330, Trident 350, V2.4 350, RatRig 3.1 400, Annex K3 etc.)
# Print Gcode Files
# Configuration versioning / branching / usage notes
    The repo seems to have many config files and macros (for Klipper, Moonraker, FilGuard, etc.). The README lists key features, but doesn’t document how to enable/disable certain features or switch configurations (e.g. how to enable the full 11-lane TradRack, or what to change if someone uses fewer lanes).
# How to run / use — startup, macros, common workflows
    There’s no section describing how to actually run / print — e.g. how to start a print, recommended slicer settings (since some are implied, like “RSCS fan auto-on at layer 30 (or user-defined)”), any safety notes, maintenance recommendations, backup/restore steps, etc.
# Testing, validation, known limitations / issues
    You have a Tests/ folder (e.g. for speed/acceleration tests, skew, etc). README mentions folder structure but doesn’t describe what the tests cover, how to run them, or what known issues/limitations remain. That would be useful, especially for others reusing the config or for your own future reference.
# Documentation of macros and config file details
    The README gives a nice summary-level bullet list of macros/features. But many details — e.g. parameters, their defaults, how to customize them (for example fan-on layer, purge tower behavior, run-out sensors reset, etc) — are only in the config files. It could help to link or list important macros with a brief explanation / usage tip
# Change history / versioning / roadmap
    You have a RoadMap/ folder, but README doesn’t include a “What’s next / planned features / roadmap” section. Adding that could help track ongoing/future improvements and give context to others.
# Contributing / License / Contact / Support
    While the repo has a LICENSE (GPL-3.0), the README does not include a dedicated “License” section, nor guidelines for contributors, nor contact or issues guidelines. If you ever expect others to use or contribute, that’d help.
# Photos / Visual documentation
    The README includes a few images (full printer view, close-up, spool tower). That’s great. But perhaps a link to a user manual, wiring diagrams, macro examples, or a sample print log could make the documentation more useful long-term.

## Improve README.md
- Add a “Usage / How to Print” section: describe a typical workflow (choose tool/spool with Spoolman, slice with Orca Slicer        settings, upload gcode, start print, post-print maintenance). Possibly mention your macros for fan control and how to tweak them.
- Perhaps include a “Troubleshooting / Known Issues” part: any quirks you know (e.g. related to multi-color purge waste, sensor mis-fires, calibration drift, filament run-out reliability, etc).
- Optionally: link to external docs or diagrams (if any) — e.g. wiring, frame assembly, how things are put together; maybe bring in a PDF or include in My_Installation/.

# ⚠️ Potential Discrepancies or Things to Watch Out For
- As with many custom printer configs — the complexity (11-lane, multi-color, all-wheel drive, triple-Z, custom macros, sensors, etc) makes maintenance harder. Without clear documentation of each macro/config section, future debugging could be painful.
