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

Once the plugin has been correctly installed and is working, it is highly recommended to configure the Patch Manager to point to your personal bank/preset location(s) for loading and saving patches.  Please refer to the support article [HERE](//2024/02/06/patch-manager-introduction) for more information about how to use the Patch Manager.

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

[//](//)

We also highly recommend reading and referring to the official manuals and documentation from the manufacturer; these resources will answer most questions about how to actually use the synths and their various features and options if you are unfamiliar with them.
