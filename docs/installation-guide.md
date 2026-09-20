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

## Installation Guide (general for all Emulators)

**Download the Plugin Files**

Our emulators are provided in many different formats (VST, VST3, CLAP, AU, LV2) and for various operating systems (Windows, MacOS, Linux).  Depending upon the capabilities of the original hardware synthesizer, many of our emulators also come in "FX" versions which may be used as Audio Effects plugins to process external audio signals rather than behave as Instrument plugins.

Download and unzip/unpackage file(s) for any of the official "release" plugin versions of each emulator you wish to install from the following links:

[Osirus (Virus A/B/C) Downloads](/downloads/osirus)  
  
[OsTIrus (Virus TI) Downloads](/downloads/ostirus)

[Vavra (microQ) Downloads](/downloads/vavra)  
  
[Xenia (microWave 2/XT) Downloads](/downloads/xenia)

[NodalRed2x (Nord Lead 2x) Downloads](/downloads/nodalred2x)

[JE8086 (Roland JP-8000) Downloads](/downloads/je8086)  

**For further information, resources, discussion, and support of our plugins including the absolute latest beta versions (including the most current features and fixes) please visit our [Discord](https://discord.com/invite/WJ9cxySnsM).**

****Installing the plugin files****

Place the unzipped/unpackaged plugin files into your appropriate plugin folder(s) used by your DAW(s). The default locations for each OS are listed below, however if you have customized your environment put them in your specific folders:

Windows:

**VST2:    C:\\Program Files\\Steinberg\\VSTPlugins  
VST3:    C:\\Program Files\\Common Files\\VST3  
CLAP:    C:\\Program Files\\Common Files\\CLAP  
LV2:     C:\\Program Files\\Common Files\\LV2**

MacOS:  
  
Note:  MacOS requires that plugins be "signed" in order for the OS to allow use of these files.  We provide a script in the downloads for each plugin that can be executed via the Terminal program to allow these to be seen by your DAW(s).  Simply uncompress the plugin archive, double-click the included 'macsetup_\[synthname\].command' file, then copy the plugin file to the correct plugin folder location. If you do not perform this activity each time you install or update our plugins, your DAW will not detect these plugins and you will not be able to use them. 

**VST2:    /Library/Audio/Plug-Ins/VST  
VST3:    /Library/Audio/Plug-Ins/VST3  
AU:      /Library/Audio/Plug-Ins/Components  
CLAP:    /Library/Audio/Plug-Ins/CLAP  
LV2:     /Library/Audio/Plug-Ins/LV2**

Linux:

**VST2:    /usr/local/lib/vst/  
VST3:    /usr/local/lib/vst3/  
CLAP:    /usr/local/lib/clap/  
LV2:     /usr/local/lib/lv2/**

On Linux you can skip the manual copying altogether and install from our package repositories instead, which also keeps the plugins updated: see [Linux: install and update with our package repositories](#linux-install-and-update-with-our-package-repositories) below.

After you install the emulator plugin and run it for the first time it will create the following folders for the various resources required for our emulators to operate. If an emulator also has an "FX" version, this centralized resource location will be shared with the Instrument version of the plugin to eliminate duplication. These plugin resource folders are located as follows (where \[synthname\] is the name of the emulator such as Osirus, OsTIrus, Vavra, Xenia, etc):

Windows: **C:\\Users\\\[username\]\\Documents\\The Usual Suspects\\\[synthname\]\\**

MacOS: **~/Documents/The Usual Suspects/\[synthname\]/**

Linux: **XDG_DATA_HOME/The Usual Suspects/\[synthname\]/**  
or  
**~/.local/share/The Usual Suspects/\[synthname\]/**

The following subfolders will be created on first use of the plugin (if not already existing):

**\\config** (plugin configuration information is stored here)  
**\\patchmanager** (patch manager database and other config data is stored here; **_NOT recommended for patch storage_**)  
**\\roms** (Firmware/ROMs must be placed here; **_emulator will not work without this_**, **_read notes below_**)  
**\\skins** (Third-Party skins must be placed here)

If they are not automatically created you may create them yourself (please note they are **lowercase**).

****Rescan/Validate your plugins in your DAW(s)****

The user will need to tell the DAW that new plugins have been added.  This is performed differently per DAW, and most DAWs will automatically rescan/refresh/validate the plugin list as plugins are added or updated. If a plugin does not show up in the plugin list, performing a rescan should be the first step to resolve that issue.

****Using the plugin****

Add the plugin to a track in the DAW and open the plugin UI.  On the first run (only once, for each plugin type) the user will be reminded of the terms of use and prompted to accept and continue.  If a valid ROM/Firmware file is not installed and detected in the **\\roms** subfolder an error message describing this may also be displayed.  Remember, without a valid ROM/Firmware file in place the emulator will not function correctly or make any sound.

Once the plugin has been correctly installed and is working, it is highly recommended to configure the Patch Manager to point to your personal bank/preset location(s) for loading and saving patches.  Please refer to the support article [HERE](/docs/patch-manager) for more information about how to use the Patch Manager.

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

The packages put the plugins into **/usr/lib/vst**, **/usr/lib/vst3**, **/usr/lib/clap** and **/usr/lib/lv2**, which nearly every DAW scans by default; if yours does not, add those folders to its plugin search paths. **If you have installed our plugins by hand before, delete your copies under /usr/local/lib/ first**, otherwise your DAW finds each emulator twice and may keep loading the old one.

Everything else on this page still applies. The packages contain no ROM/firmware, and each emulator still keeps its ROMs, skins and settings in **~/.local/share/The Usual Suspects/\[synthname\]/**.

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

This is the point of the whole exercise: new releases arrive with your normal system updates, and nothing has to be downloaded or copied by hand.

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

****Asking for help****

Please read our Support Guide which can be found [HERE](/docs/support-guide) to find out how and where to get support and assistance for our emulators.  

> PRO TIP: To avoid frustration, confusion, and running afoul of the rules, it is essential for all users to read our FAQ and Pinned Messages in the the various support channels in the Discord; answers to most of the common questions will be found in those locations. 

  
****Notes about ROM/Firmware****:

Our emulator(s) work by executing the original code (ROM/firmware) of the synth it is emulating; it is not capable of generating audio on its own.  Our emulators are intended for use only by legitimate owners of the hardware synth(s).  As such, owners of these synths typically have access to such files through the manufacturer for users entitled to do so, usually in the form of installation packages or OS system updates.  We cannot legally provide you with this ROM/firmware as part of the emulator nor provide any assistance nor accept any responsibility or liability for any illegal usage of these emulators.  Per our **#rules** published on our Discord server, no discussion of how to acquire ROM/Firmware will be tolerated in our community and may result in a ban.

> PRO TIP:  Any assistance or information we can provide is typically found in Pinned Messages (possibly called a "ROM Statement") in the appropriate support channels on the Discord.  It is probably a great idea for all users to find and read any such messages (and Pinned Messages in general). 

**ROM/Firmware files (typically found in .BIN or .MID format) should be placed in the \\roms folder inside the main plugin resource folder.** If this is not done correctly the plugin will not operate properly and will present an error screen informing you that it does not detect valid file(s) in the correct location. Most times, if you see this error it means you have either not placed these files into the correct folder or the files themselves are not valid/correct firmware files for that particular emulator. Again we cannot assist with this, so please ensure you are following that step very carefully.

Typically we only support the most recent/final release of ROM/firmware in our emulators; usage of any other versions are technically unsupported and may result in issues that we may or may not assist with (at our discretion).

  
**Notes about Third-Party Skins:**

We provide a system to create/add/use third-party skins to alter the look and feel of our emulators. Third-party skins are not officially supported by us, so if errors are encountered it is first recommended to revert to the default skin provided by the emulator to troubleshoot any issues. Please ensure that skins do not include any specifically copyrighted or trademarked design elements, logos, text/verbiage or other content; any violations of this will be removed immediately.  
  
**To install and use third-party skins, place them inside the \\skins subfolder in the main plugin resource folder.**

There are a number of extra features and options that set our emulators apart; we highly recommend browsing the entire website, especially our blogs and other articles to understand how these features work:

We also highly recommend reading and referring to the official manuals and documentation from the manufacturer; these resources will answer most questions about how to actually use the synths and their various features and options if you are unfamiliar with them.
