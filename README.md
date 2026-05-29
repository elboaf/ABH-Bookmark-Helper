# EVE Bookmark Helper (ABH)

An AutoHotkey script for EVE Online that creates/edits bookmark text with zero typing required (just hotkey presses). Systematic and automatic naming, incrementing counters, and root system tracking.

## Features

- **Root System Tracking** - Set a base system name that automatically prefixes all bookmarks
- **Auto-Incrementing Counters** - Automatically assigns numbers (1,2,3...) and letters (A,B,C...) to bookmarks
- **Signature ID Integration** - Grabs and appends signature IDs to bookmark names
- **Format Enforcer** - Fixes/Standardizes existing bookmark formatting typos
- **EVE Client Specific** - Enable/disable hotkeys per EVE client window, eg: Only enable for scanner character window.

## Default Keybindings

| Function | Default Hotkey | Description |
|----------|---------------|-------------|
| Grab Sig ID | `Ctrl+D` | Captures the first 3 characters of selected signature |
| Set Root | `Ctrl+S` | Sets root system from selected bookmark(s) |
| Format Enforcer | `Ctrl+Y` | Fixes/Enforces standard formatting on selected text |
| **Finishers** | | |
| HS (Highsec) | `Ctrl+T` | Constructs bookmark text for a HS wormhole |
| C13 (Shattered) | `Ctrl+H` | Constructs bookmark text for a C13 wormhole |
| LS (Lowsec) | `Ctrl+R` | Constructs bookmark text for a LS wormhole |
| NS (Nullsec) | `Ctrl+E` | Constructs bookmark text for a NS wormhole |
| C1 | `Ctrl+1` | Constructs bookmark text for a C1 wormhole |
| C2 | `Ctrl+2` | Constructs bookmark text for a C2 wormhole |
| C3 | `Ctrl+3` | Constructs bookmark text for a C3 wormhole |
| C4 | `Ctrl+4` | Constructs bookmark text for a C4 wormhole |
| C5 | `Ctrl+5` | Constructs bookmark text for a C5 wormhole |
| C6 | `Ctrl+6` | Constructs bookmark text for a C6 wormhole |
| E Tag (End of Life) | `Ctrl+Q` | Adds E flag |
| / Tag (Half Mass) | `Ctrl+W` | Adds / flag (overwrites C flag) |
| M Tag (Medium Hole) | `Ctrl+F` | Adds M flag (overwrites S flag) |
| S Tag (Frig Hole) | `Ctrl+G` | Adds S flag (overwrites M flag) |
| C Tag (Critical) | `Ctrl+B` | Adds C flag (overwrites / flag) |

## Installation

Download and run the precompiled .exe file. (creates `eve_bookmark_helper.ini` in the same folder to save settings)

or

1. Install [AutoHotkey v1.1](https://www.autohotkey.com/) or later
2. Save the script as `ABH_v2_multibox.ahk`
3. Double-click to run (the GUI will appear automatically)
4. The script creates `eve_bookmark_helper.ini` in the same folder to save settings

## Quick Start Guide

### 1. Set Up Your Windows
- Go to the **Windows** tab in the GUI
- Check each EVE client window where you want hotkeys active (typically just your scanner)

### 2. Understanding Root Mode

The script has two modes:

**Home/Zero Mode** (default on launch or after clicking "Clear Root")
- Bookmark format EG: `1-XYZ 3` or `A-XYZ H`
- Use when you don't need a system prefix

**Active Mode** (after setting a root system, EG: root: 1)
- Bookmark format: `11-XYZ 3` or `1A-XYZ H`
- Root system prefixes all bookmarks automatically

### 3. Basic Workflow

#### Setting a Root System
1. Select the bookmark for the hole you are about to jump from the bookmark locations window in EVE (EG: "1-XYZ 3")
2. Press `Ctrl+S` (Set Root)
3. The script detects the root system automatically (EG: 1)
4. Status tab shows your active root and next available counters
5. Jump the wormhole into the corresponding system (EG: 1)

#### Creating Bookmarks

**Step 1: Grab Signature ID**
- Scan and warp to a wormhole in EVE.
- Select the scanned wormhole signature from the probe scanner signature list in EVE (e.g., "XYZ-123	Cosmic Signature	Wormhole	Unstable Wormhole	100.0%	37.89 AU")
- Press `Ctrl+D` (Grab Sig ID)
- This arms the auto-increment system AND copies -XYZ to your clipboard

**Step 2: Apply a Finisher**
- Right-Click the wormhole and select "Save Location" (start creating a bookmark)
- Press any finisher hotkey (e.g., `Ctrl+T` for Highsec)
- The script generates and pastes the bookmark text. EG: `1A-ZYX H` (or just `A-ZYX H` if Root is (home) mode, which is the default mode when no root is set)
- The counter automatically increments after each (Grab Sig ID) and (Finisher) combination, so the next bookmark text generation correctly reflects the numbering schema

**Step 3: Correcting Mistakes**
- If you press the wrong finisher you can correct it by simply pressing a different finisher keybind. The script updates the bookmark in place without needing to manually delete or select any text
- The script does not increment numbers/alphas unless you grab a new sig ID


### 4. Tag System Rules

The script enforces mutual exclusivity for certain tags:

- **M and S** cannot both exist (M takes precedence when setting)
- **/ and C** cannot both exist (C takes precedence when setting)
- **E** can stack with any tag
- Tag keybinds can be used on any existing bookmark text (the script recognizes and enforces proper bookmark formatting)

### 5. Format Enforcer (`Ctrl+Y`)

- Standardizes any selected EVE bookmark text to the correct format
- Useful for cleaning up manually created bookmarks

### 6. Manual Root Setting
If you forget to set your root system from an existing bookmark, it is possible to manually set your root system in the GUI.

In the **Status** tab:
- Enter a system name in "Set Root Manually"
- Click "Set Root" to set it directly
- Click "Clear Root" to return to Home/Zero mode

### 7. Re-Scanning / Updating an already scanned system
- Delete any bookmarks corresponding to rolled/expired wormholes
- Select all remaining bookmarks from the locations window in EVE (Ctrl + A to select all), then press Ctrl+S (Set Root keybind)
- The script will intelligently fill in the gaps for the next generated bookmark text based on missing sequences from the bookmark list.

EG: your bookmark list appears as follows:

1-XYZ
11-ZYX
13-YXZ
1B-ZXY

The next (j-space) bookmark generated by the script will be 12, followed by 14
The next (k-space) bookmark generated by the script will be 1A, followed by 1C
(gaps in sequence are intelligently/automatically filled in)



## Status Tab Information

The Status tab shows real-time information:
- **Current Sig ID** - Last grabbed signature ID
- **Root System** - Active root system (or "(home)" for Home/Zero mode)
- **Root Mode** - "Active" or "Home/Zero"
- **Next Numeric** - Next available number
- **Next Alpha** - Next available letter

## Troubleshooting

### Hotkeys not working
- Check that the correct EVE windows are checked in the Windows tab
- Try clicking "Refresh" to update the window list
- Restart the script
- Ping rel in discord (xD)

### Script not starting
- Ensure AutoHotkey is installed
- Right-click the .ahk file and select "Run with AutoHotkey"
- use the pre-compiled exe instead

### About tab shows wrong keybindings
- Click the Keybinds tab and verify your settings
- Restart the script/application (The About tab updates when you reopen the GUI)
