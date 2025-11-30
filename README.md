#                                               VzBot VZ.52

<p align="center">
  <a href="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/vzbot_vz.52.jpg?raw=true">
    <img src="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/vzbot_vz.52.jpg?raw=true" width="250" alt="VzBot VZ.52 view"/>
  </a>
</p>

Welcome to the VzBot VZ.52 repository! This project documents the setup, configuration, and operation 
of my advanced multi-tool, multi-material 3D printer optimized for high-quality prints at maximum speed, with a focus on
efficiency and minimal waste. By printing exclusively with PETG from Duramic3D and Hatchbox, it ensures consistent results
through simplified tuning methods. The design maximizes filament performance without requiring filtration for toxic fumes,
delivering a pleasurable printing experience—though the journey to perfection involved some frustrating moments, 
like nearly tossing the printer out a second-story window!

## Table of Contents

- [Huge Thank You](#huge-thank-you--none-of-this-happens-without-these-communities)  
- [Project Overview](#project-overview)  
- [Hardware](#hardware)  
- [Key Features & Custom Macros](#key-features--custom-macros)  
- [Software](#software) 
- [Integration](#integration) 
- [Quick Start / Installation](#quick-start--installation)  
- [About Me](#about-me)  
- [License](#license) 
- [RoadMap](https://github.com/benchdog93/VzBot-VZ.52/blob/main/RoadMap/RoadMap.md)
- [Configuration](https://github.com/benchdog93/VzBot-VZ.52/blob/main/Folder%20Layout%20Reference.md)

---

## Huge Thank You – None of This Happens Without These Communities
This printer would still be a pile of parts without the insane knowledge,
generosity, and late-night help from:

- **VzBot** – the entire Discord and the original VzBot team  
- **Fluidd** – for the best web interface on the planet  
- **Annex Engineering** – TradRak, Belay, Beacon, and endless inspiration  
- **Voron Design** – the foundation everything good is built on  
- **Orca Slicer** – making multi-color slicing actually enjoyable  

You all have my eternal gratitude.

---

## Project Overview

VzBot VZ.52 is a modular 3D printer setup designed for multi-material printing using a single extruder and an Annex Tradrack MMU system. The repository includes:

- Printer firmware configs (Klipper, Moonraker, Fluidd, Mobileraker, ect.)  
- Macros for printing, calibration, airflow, dry box, and display management  
- Tests, calibration files, and images documenting the printer  
- Installation guides and historical archives  

### Images

<p align="center">
  <a href="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/vzbot_full.jpg?raw=true">
    <img src="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/vzbot_full.jpg?raw=true" width="250" alt="Full printer view"/>
  </a>
  &nbsp;&nbsp;
  <a href="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/tradrack_closeup.jpg?raw=true">
    <img src="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/tradrack_closeup.jpg?raw=true" width="250" alt="TradRack close-up"/>
  </a>
  &nbsp;&nbsp;
  <a href="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/spool_tower.jpg?raw=true">
    <img src="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/spool_tower.jpg?raw=true" width="250" alt="11-lane spool tower"/>
  </a>
</p>


---

## Hardware
<details> <summary><strong>Frame & Motion</strong></summary>

Platform: VzBot VZ.52 – limited_corexy (AWD)

XY Motion: All-Wheel-Drive

4× LDO 42STH48-2504AC, 2.5 A (X, X1, Y, Y1)

Z Axis: Triple Independent Z

3× Tronxy 1.8° 24 V 1.68 A steppers

TR8×2 leadscrews

Bed Assembly:

330×330 mm, 8 mm cast aluminum

750 W, 120 V silicone heater

NTC 100K 3950 thermistor

</details>
<details> <summary><strong>Electronics</strong></summary>

Mainboard: Fly Super∞ Pro HV (STM32H723)

Expansion: Fly DP5

Drivers:

4× TMC5160 Pro (XY)

4× TMC2209 (Z×3, Extruder)

Display: BIGTREETECH 7" HDMI Touch

Endstops: Mechanical X/Y limit switches

Host Controller: Raspberry Pi 4B (8 GB, Bookworm Lite)

USB Hub: Sabrent 4-port USB 3.0 w/ LED switches

Webcam: Raspberry Pi Camera Module 3 (Crowsnest)

</details>
<details> <summary><strong>Toolhead & Toolchanger</strong></summary>

Toolchanger:

FLY ERCF Easy BRD V1.1

TradRack 11-Lane (10 colors + 1 continuous spool)

Extruder: Vz-HextrudORT

Hotends: Trianglelab CHC Pro & CHC XL

Nozzles: Micro Swiss CM2

Hotend Cooling: VaLVnAtOr V2 air duct

Part Cooling: CPAP blower + custom flap controller

Layer Cooling: RSCS (Revo Stealth Cooling System) – auto-on at user-defined layer

</details>
<details> <summary><strong>Sensors & Probing</strong></summary>

Z Probe: BeaconH contact probe (full calibration + macros)

Filament Monitoring: Smart FilGuard runout sensors

Cutter: Magneto toolhead-mounted filament cutter

</details>
<details> <summary><strong>Power</strong></summary>

24 V Supply: Mean Well LRS-350-24

48 V Supply: Mean Well LRS-350-48 (for TMC5160 Pro HV)

</details>
<details> <summary><strong>Enclosure & Lighting</strong></summary>

Enclosure: Open-air (no enclosure)

Lighting:

3× 12 V LED light bars

5 V RGB status bar

</details>
<details> <summary><strong>Extras</strong></summary>

Spoolman integration

Custom dry-box with PTC heaters

Stepper-flip nozzle wiper

</details>
---

## Key Features & Custom Macros
- Full 11-lane TradRack with color-to-tool mapping and **smart minimal-waste purge**. See [smart_purge.cfg](https://github.com/benchdog93/VzBot-VZ.52/blob/main/VzBot%20VZ.52/smart_purge.cfg)
- RSCS fan automatically turns on at layer 30 (or any layer you set in slicer via `GCODE_AT_LAYER`), see [fans.cfg](https://github.com/benchdog93/VzBot-VZ.52/blob/main/VzBot%20VZ.52/fans.cfg) and other fan macros
- BeaconH full integration (calibration, surface scan, eddy current compensation)
- Triple-Z independent homing and bed mesh with Beacon, see [beacon.cfg](https://github.com/benchdog93/VzBot-VZ.52/blob/main/VzBot%20VZ.52/beacon.cfg) and [bed.cfg](https://github.com/benchdog93/VzBot-VZ.52/blob/main/VzBot%20VZ.52/bed.cfg)
- Smart FilGuard runout sensors re-enabled **after** purge to prevent false plug-detect triggers
- Filament management with Magneto cutter and a load/unload pop-up, see [filament.cfg](https://github.com/benchdog93/VzBot-VZ.52/blob/main/VzBot%20VZ.52/filament.cfg)
- Stepper-flip nozzle wiper with clean/retract sequence, see [nozzle_cleaner.cfg](https://github.com/benchdog93/VzBot-VZ.52/blob/main/VzBot%20VZ.52/nozzle_cleaner.cfg)
- Automatic LED lighting control based on printer state, see [led.cfg](https://github.com/benchdog93/VzBot-VZ.52/blob/main/VzBot%20VZ.52/led.cfg)

## Software

- **Firmware:** Klipper (version: specify in your setup)  
- **Web Interfaces:** Moonraker, Fluidd, Mobileraker  
- **OS:** Raspberry Pi OS Lite (Debian Bookworm 64-bit recommended)  
- **Slicer Configs:** Provided for limited CoreXY and per-axis adjustments
- **Spoolman:** integration with real-time spool selection in Fluidd/Mainsail
- **Samba:** implimentation of SMB and Active Directory allowing real-time file editing and management, see [INSTALL.md](https://github.com/benchdog93/VzBot-VZ.52/blob/main/My_Installation/INSTALL.md) for installing Samba


## Integration

###            VzBot VZ.52 is integrated into HomeAssistant/Moonraker integration 
<p align="center">
  <a href="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/HA_VzBot.jpg?raw=true">
    <img src="https://github.com/benchdog93/VzBot-VZ.52/blob/main/Photos/HA_VzBot.jpg?raw=true" width="250" alt="HA VzBot view"/>
  </a>
</p>

## Key features: 
- automated filament dring
- remote access and control to VzBot VZ.52 from anywhere
- power consumption data via a Shelly 1pm flashed with ESPHome firmware
- idle printer shutdown
- You can see my HomeAssistant automations here, [homeassistant](https://github.com/benchdog93/VzBot-VZ.52/tree/main/homeassistant)

---

## Quick Start / Installation

### Prerequisites

1. Raspberry Pi 4 or newer  
2. MicroSD card with Debian Bookworm Lite (64-bit)  
3. Klipper, Moonraker, Fluidd, Mobileraker, Crowsnest, Klipper Screen, Gcode Shell Command installed  
4. TradRack, Beacon, Belay, ResHelper, Spoolman, Per Axis Acceleration (kdb424) installed  
5. Python 3.11+ (for scripts and macros)  

> For detailed installation instructions, see [INSTALL.md](https://github.com/benchdog93/VzBot-VZ.52/blob/main/My_Installation/INSTALL.md)

### Steps

1. Clone the repository to your Raspberry Pi:

```

git clone https://github.com/benchdog93/VzBot-VZ.52.git
cd VzBot-VZ.52

```

2. Edit to your configuration and migrate to /home/pi/printer_data/config

## About Me
I am a retired explorer of both the physical and creative worlds—a tech enthusiast, photographer, paddler, hiker, 
and mountain climber driven by curiosity and a lifelong commitment to learning. Entirely self-taught and proudly adaptive, 
I approach every challenge with a mindset grounded in continuous improvement. I refuse to pair the words
 “I cannot,” believing instead that mistakes are simply stepping-stones on the path toward mastery.

As a photographer, my creative philosophy guides everything I produce:
creating images about, not of; creating questions, not understanding; seeking contemplation, not interpretation.
My work is meant to invite viewers to pause, wonder, and see the world from a different angle.

I’ve always been the one who asks the most “annoying” question—why—and I embrace that curiosity as the driving force
 of my evolution. Whether I’m experimenting with technology, exploring the outdoors, or integrating AI into my creative workflow, 
 I thrive at the intersection of innovation and introspection.

My commitment to physical, mental, and spiritual well-being shapes my path forward, 
with a renewed focus on putting myself first as I continue to grow, adapt, and reinvent.

– benchdog93 (Ed)

## License

Licensed under the **GNU General Public License v3.0 (GPL-3.0)**.  
This license ensures that any modifications or derivative works remain open-source.  
For complete details, see the [LICENSE](./LICENSE) document.
