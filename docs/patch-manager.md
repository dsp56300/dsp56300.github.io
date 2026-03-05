---
title: "Patch Manager Guide"
layout: default
permalink: /docs/patch-manager
---

```
██████╗  █████╗ ████████╗ ██████╗██╗  ██╗
██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║
██████╔╝███████║   ██║   ██║     ███████║
██╔═══╝ ██╔══██║   ██║   ██║     ██╔══██║
██║     ██║  ██║   ██║   ╚██████╗██║  ██║
╚═╝     ╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝
███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗
████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗
██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝
██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗
██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
```

# Patch Manager

The **Patch Manager** is the central hub for organizing, browsing, and managing presets across all Gearmulator emulations. It replaces the earlier Preset Browser with a modern database-driven approach — instead of navigating banks and files on disk, you work with **categories**, **tags**, and **favourites** to find and organize your sounds.

The Patch Manager is part of the plugin itself and can be accessed by clicking **Presets** (Osirus), **Patches** (Vavra), or **Browser** (OsTIrus, Xenia, NodalRed2x, JE-8086) depending on which emulator you are using.

![](/images/posts/patch-manager-introduction/image-11.png)

## Supported File Formats

The Patch Manager can import presets from a wide range of file formats:

**All Emulations:**
- `.syx` / `.mid` — Standard MIDI System Exclusive dumps
- `.fxb` / `.vstpreset` — Presets saved by DAW (VST2/VST3 format)
- `.cpr` — Cubase Project Files containing presets

**Osirus / OsTIrus (Access Virus):**
- `.syx` / `.mid` — Virus A/B/C/TI/TI2/Snow preset dumps
- `.mid` — Virus A/B/C OS Update files (factory presets are extracted automatically)
- `.lib` — SoundDiver library import for Virus A/B/C presets
- `.vti` — Virus TI backup files
- `.tfx` — TDM plugin presets (Pro Tools)
- Virus TI "Total Integration" control presets
- TC Electronic PowerCore presets

**Vavra / Xenia (Waldorf):**
- `.syx` / `.mid` — microQ / Microwave II/XT preset dumps

**NodalRed2x (Nord Lead):**
- `.syx` / `.mid` — Nord Lead 1/2/2x preset and performance dumps

**JE-8086 (Roland JP-8000):**
- `.syx` / `.mid` — JP-8000/8080 Patch and Performance dumps
- `.pat` — JP-8000/8080 Patch files
- `.pfm` — JP-8000/8080 Performance files

## Data Sources

![](/images/posts/patch-manager-introduction/image-1.png)

Patches are provided by various **Data Sources**. Where applicable, ROM/factory presets are automatically added (not for Waldorf or Nord synths due to the way they work in the hardware). Additional patches from disk can be added via right-click on the **Data Sources** node — select a file or even a whole folder to add it to the database. Folders are scanned recursively, so you can point it at your entire preset collection.

It is highly recommended to keep your patches and banks located on disk **separately from your plugin and config folder locations** to avoid operating system permissions issues and to prevent slowness of startup performance.

## Categories, Tags & Favourites

In the database, patches can be organized into **Categories**, **Tags**, and **Favourites**. Some manufacturers include category information in their patch format — you can modify these or create your own by right-clicking on the appropriate heading and selecting **Add**.

![](/images/posts/patch-manager-introduction/image-9.png)

**Key features:**

- Categories, tags, and favourites can each be **colored** — the color is displayed in search results for quick visual identification
- **Text-based filtering** allows searching data sources, tags, and patch lists
- **Drag & drop** to assign tags: drag patches onto a category/tag/favourite to add them. Hold **Shift** while dragging to remove
- **Non-destructive**: The original patch files are never modified. All changes (tag additions, removals, renames) are stored separately as deltas

![](/images/posts/patch-manager-introduction/image-2.png)

![](/images/posts/patch-manager-introduction/image-3.png)

![](/images/posts/patch-manager-introduction/image-4.png)

Additionally, each emulation may define its own custom tag types. For example, Osirus provides **Virus Model** and **Virus Features** tags to help narrow down patches by hardware generation or synthesis features used.

## Searching & Filtering

The Patch Manager provides several ways to find patches:

- **Text search** — Type in the filter bar to search patch names (case-insensitive)
- **Tag filtering** — Click on categories, tags, or favourites in the tree to filter the patch list
- **Hide duplicates by hash** — Removes exact duplicates from the list (same patch data)
- **Hide duplicates by name** — Removes patches with the same name

Searches run in the background, so the UI stays responsive even with large databases.

## Patch List

The patch list supports two layout modes, selectable via the right-click context menu:

- **List + Info view** — Shows patches in a list with a detailed information panel
- **Grid view** — Alternative grid-based layout

**Context menu options** (right-click on patches):
- **Export selected / Export all** — Export patches to `.syx` or `.mid` files
- **Rename** (F2) — Rename patches (User Banks only)
- **Locate** — Navigate to the patch's data source in the tree
- **Delete** — Remove patches (User Banks only, with confirmation)
- **Add/Remove tags** — Assign or remove categories, tags, and favourites via submenus
- **Hide duplicates** — Toggle duplicate filtering by hash or name

## User Banks

**User Banks** allow you to save and organize your custom patches. Create a User Bank by right-clicking on **User** and selecting **Create**, then add patches by dragging them from the patch list into the User Bank.

![](/images/posts/patch-manager-introduction/image-5.png)

To export a User Bank for use with hardware, right-click to show the context menu and choose your export format (`.syx` or `.mid`).

![](/images/posts/patch-manager-introduction/image-6.png)

If you intend to export a User Bank to the actual hardware synth, consider limiting the number of patches to fit within the hardware bank size (typically 128). Patches beyond the hardware limit will be ignored when importing.

**Additional User Bank features:**
- **Paste from Clipboard** — Paste patch data directly into a User Bank
- **Reveal in File Browser** — Open the storage location in your OS file manager
- Patches can be **reordered** within a User Bank by dragging

## Patch Navigation

- **Previous / Next** patch navigation is available per part
- **Program changes** via MIDI are reflected in the Patch Manager — the selected patch updates automatically
- On multi-part synths, each part tracks its own active patch independently

## Technical Information

### Storage Format

The database keeps track of which data sources have been added, stored at:

**(Windows)** `C:\Users\[username]\Documents\The Usual Suspects\[synthname]\patchmanager\patchmanagerdb.json`  
**(macOS)** `~/Documents/The Usual Suspects/[synthname]/patchmanager/patchmanagerdb.json`

A binary cache (`patchmanagerdb.cache`) is maintained alongside the JSON for fast loading.

User banks are stored in the same folder in sysex format:

**(Windows)** `C:\Users\[username]\Documents\The Usual Suspects\[synthname]\patchmanager\MyUserBank.syx`  
**(macOS)** `~/Documents/The Usual Suspects/[synthname]/patchmanager/MyUserBank.syx`

### Patch Modifications

Modifications to patches are stored as deltas next to the imported file. For example, if you imported:

_Rob Papen Signature Soundset.MID_

There will be a companion file:

_Rob Papen Signature Soundset.MID.json_

These JSON files store only the differences — added or removed tags compared to the source. Example:

```json
{
  "patches": {
    "prog|0|hash|e1356f571f1194f5b3e3744321fca010": {
      "tags": {
        "category": {
          "removed": ["Favourite 3"]
        }
      }
    }
  }
}
```

In this case, the category "Favourite 3" has been removed from the first patch of that bank.

### Patch Identification

Each patch is identified by an **MD5 hash** of its data. This allows the Patch Manager to detect duplicates and track patches across data sources even when files are moved or renamed.

## Backup Strategy

- **Imported patches**: All tag modifications are saved as `.json` files next to the source file. When backing up your presets, copy the `.json` companion files along with them.
- **User banks**: Stored in the Application Support / Roaming folder (see above). Copy the entire folder, or the individual `.syx` and `.json` files.
- **Recovery**: If you accidentally remove a user bank from the database, you can create a "new" user bank with the same name. If the `.syx` file still exists on disk (they are never physically deleted), it will be loaded automatically — the **Create** effectively becomes an **Add**.
