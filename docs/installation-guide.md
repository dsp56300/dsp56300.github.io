---
title: "Installation Guide"
layout: default
permalink: /docs/installation-guide
---

```
██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
```

## The short version

1. Download the **TUS Plugin Manager** for your system:
   [Windows](/builds/downloads?product=PluginManager&format=All&os=win64) /
   [macOS](/builds/downloads?product=PluginManager&format=All&os=MacOS) /
   [Linux x64](/builds/downloads?product=PluginManager&format=All&os=Linux_x86_64) /
   [Linux aarch64](/builds/downloads?product=PluginManager&format=All&os=Linux_aarch64)
2. Unpack it and start it ([details per system](#starting-the-plugin-manager)).
3. Tick the emulators and plugin formats you want and click **Install selected**.
4. Put the ROM of each emulator into its `roms` folder ([see below](#roms)).
5. Let your DAW rescan its plugins.

From then on the Plugin Manager tells you when an update is out and installs it with one click.

> **88EmuPlayer** is a standalone program rather than a DAW plugin, so the plugin folder and DAW steps do not apply to it. Install it with the Plugin Manager, or unzip it anywhere, and run it; when you select a device to emulate, it guides you through installing that device's ROM files. See the [88EmuPlayer Usage Guide](/downloads/88emuplayer#usage-guide) for the macOS first-launch steps and the rest of its setup.

## The Plugin Manager

The Plugin Manager downloads our emulators and puts every plugin format into the folder your DAW looks in. It lists every emulator we have released, with the version you have installed of each format, and installs, upgrades, downgrades and removes them for you. It works on Windows, macOS and Linux, and also finds plugins you installed by hand before.

### Starting the Plugin Manager

**Windows:** Unpack the archive, for example into your Documents folder, and run `TUS Plugin Manager.exe`. The plugin folders on Windows belong to the system, so Windows asks for administrator rights when plugins are copied into them. Only that copying runs with those rights, and declining leaves everything as it was.

**macOS:** Unpack the archive and move `TUS Plugin Manager.app` into your Applications folder. The app is not signed, so macOS blocks its first start: open **System Settings › Privacy & Security**, scroll down and click **Open Anyway**. On older macOS versions, right-click the app and choose **Open**. The plugins it installs need no such step, it takes care of that itself.

**Linux:** Unpack the archive and run `usr/local/bin/TUS Plugin Manager` from it.

### Using it

* Every emulator is a row with a column per plugin format. A column shows the version you have installed, and its button installs it, upgrades it, puts an older version back or removes it. The dropdown offers every released version. The **All** column does the same for every format of an emulator at once.
* **Install selected** installs every format you ticked, **Upgrade all** upgrades everything you have installed that has an update. Nothing is ticked on the first start, and the Plugin Manager remembers what you tick.
* Emulators with an update are listed first, under **Updates available**.
* Effect versions such as OsirusFX come with the emulator they belong to.
* Click an emulator to see its page: its formats, its **Changelog**, **Uninstall all**, and **Back up now**, which saves everything the emulator keeps in its data folder (settings, patch manager database, ROMs and skins) so that you can restore it later.
* When a new version of the Plugin Manager itself is out, a button at the top offers the update.
* Donators: **Donator login** adds the builds for the emulators you support. Paste the login line you received, or drop the login file onto the window.

### Where the plugins go

| Format | Windows | macOS | Linux |
| --- | --- | --- | --- |
| VST3 | `C:\Program Files\Common Files\VST3` | `~/Library/Audio/Plug-Ins/VST3` | `~/.vst3` |
| VST2 | `C:\Program Files\VSTPlugins` | `~/Library/Audio/Plug-Ins/VST` | `~/.vst` |
| CLAP | `C:\Program Files\Common Files\CLAP` | `~/Library/Audio/Plug-Ins/CLAP` | `~/.clap` |
| LV2 | `C:\Program Files\Common Files\LV2` | `~/Library/Audio/Plug-Ins/LV2` | `~/.lv2` |
| AU | | `~/Library/Audio/Plug-Ins/Components` | |
| Programs | `C:\Program Files\The Usual Suspects` | `~/Applications` | `~/.local/bin` |

These are the folders DAWs scan by default. If yours uses others, change them in **Preferences**.

### If something goes wrong

The Plugin Manager writes a `log.txt` into its own folder, **Documents/The Usual Suspects/PluginManager/config** (on Linux **~/.local/share/The Usual Suspects/PluginManager/config**). Please attach it and `installed.json` from the same folder when you ask for help.

There is also `tuspm`, the same program without a window, for scripts. Its commands are described in the [Plugin Manager README](https://github.com/dsp56300/gearmulator/blob/main/doc/pluginmanager_readme.md).

## ROMs

Our emulators run the original firmware (the ROM) of the synthesizer they emulate, and make no sound without it. We cannot provide ROMs, the Plugin Manager does not download them, and per the rules of our Discord server asking where to get them leads to a ban. Owners of the hardware usually get them from the manufacturer, as an OS update or installation package.

Put the ROM files, usually `.bin` or `.mid` files, into the `roms` folder inside the emulator's data folder:

| | |
| --- | --- |
| Windows | `Documents\The Usual Suspects\<emulator>\roms` |
| macOS | `~/Documents/The Usual Suspects/<emulator>/roms` |
| Linux | `~/.local/share/The Usual Suspects/<emulator>/roms` (or under `$XDG_DATA_HOME`) |

`<emulator>` is its name, such as Osirus, Vavra or JE8086. An effect version shares the folder of its emulator. The emulator creates the folder when it runs for the first time; you can also create it yourself, all lowercase. Beside it, the emulator keeps `config`, `patchmanager` and `skins`.

If the emulator cannot find a valid ROM, it shows an error instead of its user interface. That nearly always means the file is in the wrong folder, or is not the firmware this emulator needs. We support the final firmware release of each synthesizer; other versions may or may not work.

## Rescan in your DAW

Most DAWs notice new and updated plugins on their next start. If an emulator does not appear, start a plugin rescan in your DAW's settings.

The first time you open an emulator it shows its terms of use, once per emulator. Then set up the [Patch Manager](/docs/patch-manager) with the folders that hold your banks and patches.

## Installing by hand

You do not need the Plugin Manager. Every emulator's [download page](/downloads) has the archives for each system:

1. Unpack the archive of each plugin format you want.
2. **macOS only:** double-click the `macsetup_<emulator>.command` file that comes with the plugin. The plugins are not signed, and without this step macOS refuses to load them. Do this again after every update.
3. Copy the plugin into the plugin folder of its format: the folders [listed above](#where-the-plugins-go), or the system-wide ones (`/Library/Audio/Plug-Ins/…` on macOS, `/usr/local/lib/vst3` and so on on Linux).

## Linux: install and update with our package repositories

On Linux there is an alternative to downloading and unpacking an archive for every release: our package repositories, which are built and hosted for us by the openSUSE Build Service. Add the repository once, install the emulators you want, and from then on your package manager updates them along with the rest of your system.

There is one package per emulator, each containing that emulator's VST2, VST3, CLAP and LV2 plugin:

| Package | Emulator |
| --- | --- |
| `theusualsuspects-osirus` | Osirus (Virus A/B/C) |
| `theusualsuspects-ostirus` | OsTIrus (Virus TI) |
| `theusualsuspects-vavra` | Vavra (microQ) |
| `theusualsuspects-xenia` | Xenia (Microwave II/XT) |
| `theusualsuspects-nodalred2x` | NodalRed2x (Nord Lead 2x) |
| `theusualsuspects-je8086` | JE-8086 (Roland JP-8000) |
| `theusualsuspects-88emu` | 88emuPlayer and 88EmuCli, which are programs rather than plugins |

The packages put the plugins into **/usr/lib/vst**, **/usr/lib/vst3**, **/usr/lib/clap** and **/usr/lib/lv2**, which nearly every DAW scans by default; if yours does not, add those folders to its plugin search paths. **If you have installed our plugins by hand or with the Plugin Manager before, remove those copies first**, otherwise your DAW finds each emulator twice and may keep loading the old one.

The packages contain no ROM/firmware, and each emulator still keeps its ROMs, skins and settings in **~/.local/share/The Usual Suspects/\[synthname\]/**.

### Which repository do I use?

Most distributions are built on one of the systems we build for and use that repository. Match the release exactly: from Ubuntu 24.04 and Debian 13 onwards the packages need `libasound2t64`, which older releases do not have.

| Your system | Repository name |
| --- | --- |
| Debian 13, Debian 12 | `Debian_13`, `Debian_12` |
| Ubuntu 22.04, 24.04, 26.04, including Kubuntu, Xubuntu, Lubuntu and Ubuntu Studio | `xUbuntu_22.04`, `xUbuntu_24.04`, `xUbuntu_26.04` |
| Linux Mint | the Ubuntu LTS it is built on: Mint 21 uses `xUbuntu_22.04`, Mint 22 uses `xUbuntu_24.04` |
| Pop!\_OS, elementary OS, Zorin OS, KDE neon | the Ubuntu LTS it is built on, for example Pop!\_OS 22.04 uses `xUbuntu_22.04` |
| LMDE, MX Linux, AV Linux | the Debian release it is built on, for example LMDE 6 uses `Debian_12` |
| Fedora 43, 44, including Nobara and Ultramarine | `Fedora_43`, `Fedora_44` |
| openSUSE Tumbleweed | `openSUSE_Tumbleweed` |
| openSUSE Leap 16.0 | `16.0` |
| Arch, including EndeavourOS, CachyOS and Garuda | `Arch` |

All repositories are 64-bit Intel/AMD. ARM (aarch64) packages exist for Debian 13, Fedora 43 and 44, openSUSE Leap 16.0 and Tumbleweed, so a Raspberry Pi 4 or 5 running Debian 13 or Fedora is covered; other ARM systems should use the portable Linux aarch64 downloads. Manjaro holds Arch updates back for a few weeks, so a fresh package there can occasionally want a library that Manjaro has not shipped yet.

### Debian, Ubuntu and derivatives

Replace `Debian_13` with your repository from the table above, in both commands:

```
curl -fsSL https://download.opensuse.org/repositories/home:/theusualsuspects/Debian_13/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/theusualsuspects.gpg

echo "deb [signed-by=/usr/share/keyrings/theusualsuspects.gpg] https://download.opensuse.org/repositories/home:/theusualsuspects/Debian_13/ /" | sudo tee /etc/apt/sources.list.d/theusualsuspects.list

sudo apt update
sudo apt install theusualsuspects-osirus
```

### Fedora

```
sudo dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:/theusualsuspects/Fedora_44/home:theusualsuspects.repo

sudo dnf install theusualsuspects-osirus
```

On older Fedora releases the first command is `sudo dnf config-manager --add-repo <url>`.

### openSUSE

```
sudo zypper addrepo https://download.opensuse.org/repositories/home:/theusualsuspects/openSUSE_Tumbleweed/home:theusualsuspects.repo

sudo zypper refresh
sudo zypper install theusualsuspects-osirus
```

On Leap 16.0, replace `openSUSE_Tumbleweed` with `16.0`.

### Arch

Trust our signing key, then add the repository:

```
curl -fsSL https://download.opensuse.org/repositories/home:/theusualsuspects/Arch/x86_64/home_theusualsuspects_Arch.key | sudo pacman-key --add -

sudo pacman-key --lsign-key 6F616D60DB991ED61A6F29B0006C0F47711C6743
```

Add these two lines at the end of **/etc/pacman.conf**:

```
[home_theusualsuspects_Arch]
Server = https://download.opensuse.org/repositories/home:/theusualsuspects/Arch/$arch
```

Then install:

```
sudo pacman -Sy theusualsuspects-osirus
```

### Updating

New releases arrive with your normal system updates, and nothing has to be downloaded or copied by hand.

```
sudo apt update && sudo apt upgrade          # Debian, Ubuntu
sudo dnf upgrade                             # Fedora
sudo zypper refresh && sudo zypper update    # openSUSE
sudo pacman -Syu                             # Arch
```

Your ROMs, skins, settings and patch manager database live in your home folder and are untouched by an update. The repositories follow our public releases; the newest beta builds are announced on our [Discord](https://discord.com/invite/WJ9cxySnsM) and are not part of them.

### Removing

Removing a package takes the plugins with it and leaves your home folder alone:

```
sudo apt remove theusualsuspects-osirus      # Debian, Ubuntu
sudo dnf remove theusualsuspects-osirus      # Fedora
sudo zypper remove theusualsuspects-osirus   # openSUSE
sudo pacman -R theusualsuspects-osirus       # Arch
```

## Skins

Third-party skins go into the `skins` folder beside `roms`. We do not support them officially: if something misbehaves, switch back to the built-in skin first. Skins must not contain copyrighted or trademarked designs, logos or text. To make your own, see the [Skinning Guide](/docs/rmlui-skinning).

## Getting help

Read our [FAQ](/docs/faqs) and the pinned messages in the support channels of our [Discord](https://discord.com/invite/WJ9cxySnsM) first; most questions are answered there. How and where to ask for help is in our [Support Guide](/docs/support-guide). For how to use the synthesizers themselves, the manufacturers' manuals are the best reference.
