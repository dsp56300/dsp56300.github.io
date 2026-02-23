---
title: "Frequently Asked Questions"
layout: default
permalink: /docs/faqs
---

```
███████╗ █████╗  ██████╗ ███████╗
██╔════╝██╔══██╗██╔═══██╗██╔════╝
█████╗  ███████║██║   ██║███████╗
██╔══╝  ██╔══██║██║▄▄ ██║╚════██║
██║     ██║  ██║╚██████╔╝███████║
╚═╝     ╚═╝  ╚═╝ ╚══▀▀═╝ ╚══════╝
                                 
```

1. [General FAQ](//faqs/#general-faq)
2. [Discord FAQ](//faqs/#discord-faq)
3. [Osirus VST/AU/CLAP/LV2 FAQ (Access Virus A/B/C)](//faqs/#osirus-vst-au-clap-lv2-faq-access-virus-a-b-c)
4. [OsTIrus VST/AU/CLAP/LV2 FAQ (Access Virus TI/Snow)](//faqs/#ostirus-vst-au-clap-lv2-faq-access-virus-ti-snow)
5. [Vavra VST/AU/CLAP/LV2 FAQ (Waldorf microQ)](//faqs/#vavra-vst-au-clap-faq-microq)
6. [Xenia VST/AU/CLAP/LV2 FAQ (Waldorf microWAVE 2/XT)](//faqs/#xenia-vst-au-clap-faq-microq)
7. [NodalRed2x VST/AU/CLAP/LV2 FAQ (Clavia Nord Lead 2x)](//faqs/#nodalred2x-vst-au-clap-faq-microq)
8. [JE8086 VST/AU/CLAP/LV2 FAQ (Roland JP-8000 and soon JP-8080)](//faqs/#je8086-vst-au-clap-faq-microq)

## General FAQ

**Q: What is this project all about?**

A: The goal of this project is to preserve various digital musical instruments and effects processors through the emulation of the DSP processors utilized by musical instrument manufacturers from the 1990s through the late 2000s.

**Here is a list of synths we are potentially working towards emulation of:**

| Device | DSP | Quantity | Status |
| --- | --- | --- | --- |
| Waldorf MW2/XT | Motorola 56303 | x1 | released |
| Waldorf microQ | Motorola 56362 | x1 | released |
| Waldorf Q | 3x Motorola 56362   (2x synth, 1x FX) | x3 | research |
| Clavia Micro Modular | Motorola 56303 | x1 |  |
| Clavia Nord Modular | Motorola 56303 | x4 |  |
| Clavia Nord Lead 2X | Motorola 56362 @ 120 Mhz | x2 | released |
| Clavia Nord Lead 3 | Motorola 56362 | x6 | research |
| Novation SuperNova II | 8x Motorola 56362   1x Motorola 56303 | x9 | development |
| Novation SuperNova | Motorola 56303 | x8 | research |
| Novation Nova | 5x Motorola 56362   1x Motorola 56303 | x6 | research |
| Korg MS2000 | Motorola 56362 | x1 |  |
| Korg Microkorg | Motorola 56362 | x1 |  |
| Access Virus A | Motorola 56303 | x1 | released |
| Access Virus B | 1st rev "S" = Motorola 56303   2nd rev "T" = Motorola 56311 | x1 | released |
| Access Virus C  | Motorola 56362 | x1 | released |
| Access Virus TI Snow | Freescale 56367 | x1 | released |
| Access Virus TI & TI2 | Freescale 56367 | x2 | released |
| Roland JP8000 | Roland ESP | x4 | released |
| Roland JP8080 | Roland ESP | x5 | development |
| Roland SDX/SRV/SDE-330 | Roland CSP | x2 | development |
| Roland U-220 | 1x Roland LP   1x Roland RCC | x2 | research |
| Roland D-70 | 1x Roland LP   1x Roland TVF   1x Roland RCC | x3 | research |
| Roland JD-990 | 1x Roland EP   1x Roland TVF   2x Roland CSP | x4 | research |
| Roland SC-88Pro | Roland XP | x1 | research |
| BOSS SE-70 | Roland CSP | x1 | development |
| BOSS SX-700 | Roland ESP | x1 | development |
| BOSS GT-5 | Roland ESP | x1 | development |
| Ensoniq VFX/VFXsd/SD-1 | 1x Ensoniq OTIS   1x Ensoniq ES5510 | x2 | development |
| Ensoniq DP/4 DP/4+ | Ensoniq ES5510 | x4 | development |
| Ensoniq TS-10/12 | 1x Ensoniq OTTO   1x Ensoniq ES5510 | x2 | development |
| Ensoniq MR-Rack | 2x Ensoniq OTTO   1x Ensoniq ES5511 | x3 | research |


*

Various DSPs used in Synthesizers

*
**Q: What platforms are supported?**

A: Plugins are available for Windows, MacOS and Linux. The supported plugins formats are VST2, VST3, AU, CLAP, and LV2. Supported CPUs are x86_64 and ARM64/aarch64 (including Apple Silicon "M" series processors).

32 bit plugins are not available and will not be supported in the future.

**Q: Is this project open source?**

A: Yes, the source code can be found here: [https://github.com/dsp56300/gearmulator/](https://github.com/dsp56300/gearmulator/)

**Q: Isn't it illegal what you are doing?**

A: The emulation itself is not illegal. Sharing of the hardware ROM/Firmware and other protected materials is illegal though. What this means is that a user will need to provide the ROM/Firmware file of a synthesizer that it wants to emulate. It works similar to game console emulators, where the emulator itself cannot execute any game until you provide a ROM/Firmware of it.

**Q: What is a ROM/Firmware? Why do I need it?**

A: Our emulators work by allowing the user to execute the original code (ROM/firmware) of the device it is emulating; it is not capable of generating audio on its own.  Our emulators are intended for use only by legitimate owners of the hardware synth(s).  As such, owners of these synths typically have access to such files through the manufacturer for users entitled to do so, usually in the form of installation packages or OS system updates. We cannot legally provide you with this ROM/firmware as part of the emulator nor provide any assistance nor accept any responsibility or liability for any illegal usage of these emulators.  Per our **#rules** published on our Discord server, no discussion of how to acquire ROM/Firmware will be tolerated in our community and may result in a ban.

Typically we only support the most recent/final release of ROM/firmware in our emulators; usage of any other versions are technically unsupported and may result in issues that we may or may not assist with (at our discretion).

**Q: Where do I find the ROM/Firmware needed to run the emulator?**

A: We neither provide ROM/Firmware nor can we provide any assistance to you to find them, as distribution of copyrighted material is illegal and this is not our intention. There is absolutely no discussion of or assistance with how to find or acquire ROM/Firmware tolerated on our Discord server and any abuse of this will result in an immediate ban.

**Q: How is this emulation done?**

A: The emulator used to be an [interpreter](https://en.wikipedia.org/wiki/Interpreter_\(computing\)). The current version uses a technique called [JIT/dynarec](https://en.wikipedia.org/wiki/Just-in-time_compilation).

**Q: Is the DSP 563XX series (and the 563XX emulator too) natively compatible with the 56001, 56002, ... (the first generation of 56k DSPs)**

A: No, the DSP 56000 series is an older generation of DSPs. Compared to the 56300 series, some registers are not as wide, for example the address generation registers are 16 bit only, compared to 24 bit on the 56300 series. The hardware stack is smaller, too. Some registers do not exist at all on the older DSP series. While the DSP 56000 series could be treated as a subset of the 56300 series, support for the 56000 series would require a large rewrite of the existing code base.

**Q: Why is the emulator so CPU hungry? CPUs as of today with several GHz of processing power should be able to emulate a DSP which runs at 60MHz to 150Mhz clock speed**

A: Emulation always adds a large amount of overhead due to the nature of interpreted emulation. Furthermore, the DSP 563xx has several features that are not available on standard CPUs such as 56 bit fixed point accumulator registers, modulo addressing or hardware loops.

Therefore, the emulation uses plenty of CPU resources indeed, but is realtime capable on mid range CPUs or older high end CPUs (Core i7 4790K, ~2014) , high end CPUs such as a Ryzen 5900x or Apple M1/M2 are able to run many instances of the plugin even.

**Q: What about synthesizers based on other DSP processors besides the Motorola DSP 56300 series? Will they be CPU-hungry as well?**

A: Much like the DSP 56300 series of processors, custom chips used by other manufacturers still require a similiar emulation approach in order to be used for this project. Some of these processors are less powerful than the Motorola DSPs and may run more economically, and some may be just as CPU-hungry. Many of the non-Motorola-based instruments were implemented with a combination of different custom chips working together, so it is likely that emulating these instruments may require medium-to-heavy CPU much like the Motorola-based emulations.

**Q: Why don't you use static recompilation to reduce CPU usage and increase emulation speed? Isn't that easier than development of a JIT/dynamic recompiler?**

A: Due to legal issues, we are not allowed to recompile an existing ROM and redistribute it, as a recompilation is a derivative work of the ROM, which is copyrighted. Furthermore, parts of the DSP code are self-modifying so static recompilation does not even work at all.

**Q: Does the emulator support the Apple Silicon M-series or other ARM based CPUs?**

A: Yes, native support for ARM64-based devices is supported. This increases the execution speed on ARM64 based CPUs by several magnitudes.

Please note that a 64 bit ARM CPU aka ARMv8, ARM64 or AArch64 and a compatible OS is required, 32 bit / ARMv7 is only supported via interpreter and is very slow.

MacOS users: Use a DAW that runs natively on Apple Silicon (M-series CPUs) as a DAW running on Rosetta will cause the plugin to be run on Rosetta, too

**Q: Why is there no 32 bit support?**

A: 32 bit CPUs offer much less registers and are furthermore a limiting factor when it comes to DSP math calculations, as the DSP ALU registers are 56 bit wide and therefore do not fit into 32 bit host CPU registers. It does not make any sense to support these CPUs because even if the recompiler got ported to this architecture, it most likely won't be realtime capable.

## Discord FAQ

**Q: I cannot see any (or very few) channels on the server**

A: Common issues with the Discord server include not seeing all the channels.  This is much more of a problem when trying to use the Discord from a phone or mobile device; for best results use the Discord app or website from a computer browser.  Manage your channels in Discord by clicking on the **Channels and Roles** section, and then clicking **Browse Channels:**

![](/images/pages/faqs/discord-channel-config.png)

You may then select the Categories and/or individual channels that you wish to view from the list.  As this is our only location to provide support, it is highly recommended to at first view all channels until the server layout is familiar to you and then hide any channels that are not helpful for your personal experience.

**Q: How do I get access to the donators section?**

A: Access to the donators section of the Discord is available to anyone who has donated at least the equivalent of £20 (GBP). Details about how to donate to support this project can be found in the **#donate** channel. After a donation has been made, make a post in the **#ive-donated** channel with your transaction details to get access.

**Q: What are "Pinned Messages and why are they so important to pay attention to?**

A: Discord is primarily an interactive chat-based tool for collaboration and discussion. It is easy for important information to get lost in the conversation-style feed, so the Pinned Messages feature allows for admins to "pin" important messages (typically download links and other special and helpful information) to make this easier to find. We strongly encourage all users to review Pinned Messages on a very regular basis, especially in the "support" channels.

## Osirus VST/AU/CLAP/LV2 FAQ (Access Virus A/B/C)

This is the FAQ specific for the Osirus plugin, which emulates the Access Virus A/B/C

**Q: On MacOS, plugins do not load because they are not properly signed**

A: Plugins on MacOS need to be signed manually after installation. To do so, we have included a script called 'macsetup_Osirus.command' packaged with the MacOS plugin downloads. Simply extract the plugin archive, double-click the .command file, then copy the plugin to the desired plugin folder.

Alternatively, you can open a Terminal and execute the following commands for each format of the plugin you wish to install and use (if you have installed the plugins in a non-standard location or renamed the files, modify these commands to reflect those differences). An example for Osirus is shown below:

```
sudo xattr -cr /Library/Audio/Plug-Ins/VST3/Osirus.vst3sudo xattr -cr /Library/Audio/Plug-Ins/VST/Osirus.vstsudo xattr -cr /Library/Audio/Plug-Ins/Components/Osirus.componentsudo xattr -cr /Library/Audio/Plug-Ins/CLAP/Osirus.clapsudo xattr -cr /Library/Audio/Plug-Ins/lv2/Osirus.lv2
```

**Q: When controlling the plugin via my Master Keyboard, I get weird behavior such as volume changes / sound changes etc**

A: The Virus hardware has control changes mapped to preset parameter changes. It is very likely that your Master Keyboard emits MPE control change messages that the Virus doesn't understand. To fix this, either disable MPE on your Master Keyboard or filter them in your DAW

**Q: Why isn't there a Midi Learn function?**

A: The Virus hardware already has plenty of control changes mapped to modify presets at runtime. Changing this behavior would mean that other external controllers or editors that are designed for the Virus would stop functioning. Check the official Virus A/B/C documentation to see how the controllers are mapped  
  
A2: We realize this is a very popular request and we are currently investigating a way to add this into our emulators.

**Q: How can I develop my own skin for the plugin?**

A: Right click anywhere in the plugin and export the currently loaded skin to disk. We provide a skinning capability, please see the blog post [HERE](//2025/08/19/rmlui-new-gui-rendering-engine-skinning-system/).

## OsTIrus VST/AU/CLAP/LV2 FAQ (Access Virus TI/Snow)

This is the FAQ specific for the OsTIrus plugin, which emulates the Access Virus TI and Snow

**Q: On MacOS, plugins do not load because they are not properly signed**

A: Plugins on MacOS need to be signed manually after installation. To do so, we have included a script called 'macsetup_OsTIrus.command' packaged with the MacOS plugin downloads. Simply extract the plugin archive, double-click the .command file, then copy the plugin to the desired plugin folder.

Alternatively, you can open a Terminal and execute the following commands for each format of the plugin you wish to install and use (if you have installed the plugins in a non-standard location or renamed the files, modify these commands to reflect those differences). An example for OsTIrus is shown below:

```
sudo xattr -cr /Library/Audio/Plug-Ins/VST3/OsTIrus.vst3sudo xattr -cr /Library/Audio/Plug-Ins/VST/OsTIrus.vstsudo xattr -cr /Library/Audio/Plug-Ins/Components/OsTIrus.componentsudo xattr -cr /Library/Audio/Plug-Ins/CLAP/OsTIrus.clapsudo xattr -cr /Library/Audio/Plug-Ins/lv2/OsTIrus.lv2
```

**Q: When controlling the plugin via my Master Keyboard, I get weird behavior such as volume changes / sound changes etc**

A: The Virus hardware has control changes mapped to preset parameter changes. It is very likely that your Master Keyboard emits MPE control change messages that the Virus doesn't understand. To fix this, either disable MPE on your Master Keyboard or filter them in your DAW

**Q: Why isn't there a Midi Learn function?**

A: The Virus hardware already has plenty of control changes mapped to modify presets at runtime. Changing this behavior would mean that other external controllers or editors that are designed for the Virus would stop functioning. Check the official Virus TI documentation to see how the controllers are mapped

A2: We realize this is a very popular request and we are currently investigating a way to add this into our emulators.

**Q: How can I use the plugin in Snow mode?**

A: Click next to the ROM LOADED at the bottom of the plugin and select the version (TI2 or Snow) that you wish to run. The TI2 mode uses much more CPU than the Snow mode (because there are 2 virtual DSP chips being emulated to match the hardware) so the Snow mode may help for people with less powerful systems.

**Q: How can I develop my own skin for the plugin?**

A: Right click anywhere in the plugin and export the currently loaded skin to disk. We provide a skinning capability, please see the blog post [HERE](//2025/08/19/rmlui-new-gui-rendering-engine-skinning-system/).

## Vavra VST/AU/CLAP/LV2 FAQ (Waldorf microQ)

This is the FAQ specific for the Vavra plugin, which emulates the Waldorf microQ

**Q: On MacOS, plugins do not load because they are not properly signed**

A: Plugins on MacOS need to be signed manually after installation. To do so, we have included a script called 'macsetup_Vavra.command' packaged with the MacOS plugin downloads. Simply extract the plugin archive, double-click the .command file, then copy the plugin to the desired plugin folder.

Alternatively, you can open a Terminal and execute the following commands for each format of the plugin you wish to install and use (if you have installed the plugins in a non-standard location or renamed the files, modify these commands to reflect those differences). An example for Vavra is shown below:

```
sudo xattr -cr /Library/Audio/Plug-Ins/VST3/Vavra.vst3sudo xattr -cr /Library/Audio/Plug-Ins/VST/Vavra.vstsudo xattr -cr /Library/Audio/Plug-Ins/Components/Vavra.componentsudo xattr -cr /Library/Audio/Plug-Ins/CLAP/Vavra.clapsudo xattr -cr /Library/Audio/Plug-Ins/LV2/Vavra.lv2
```

**Q: When controlling the plugin via my Master Keyboard, I get weird behavior such as volume changes / sound changes etc**

A: The microQ hardware has control changes mapped to preset parameter changes. It is very likely that your Master Keyboard emits MPE control change messages that the microQ doesn't understand. To fix this, either disable MPE on your Master Keyboard or filter them in your DAW

**Q: Why isn't there a Midi Learn function?**

A: The microQ hardware already has plenty of control changes mapped to modify presets at runtime. Changing this behavior would mean that other external controllers or editors that are designed for the microQ would stop functioning. Check the official microQ documentation to see how the controllers are mapped

A2: We realize this is a very popular request and we are currently investigating a way to add this into our emulators.

**Q: How can I develop my own skin for the plugin?**

A: Right click anywhere in the plugin and export the currently loaded skin to disk. We provide a skinning capability, please see the blog post [HERE](//2025/08/19/rmlui-new-gui-rendering-engine-skinning-system/).

## Xenia VST/AU/CLAP/LV2 FAQ (Waldorf microWAVE 2/XT)

This is the FAQ specific for the Xenia plugin, which emulates the Waldorf microWAVE 2/XT

**Q: On MacOS, plugins do not load because they are not properly signed**

A: Plugins on MacOS need to be signed manually after installation. To do so, we have included a script called 'macsetup_Xenia.command' packaged with the MacOS plugin downloads. Simply extract the plugin archive, double-click the .command file, then copy the plugin to the desired plugin folder.

Alternatively, you can open a Terminal and execute the following commands for each format of the plugin you wish to install and use (if you have installed the plugins in a non-standard location or renamed the files, modify these commands to reflect those differences). An example for Vavra is shown below:

```
sudo xattr -cr /Library/Audio/Plug-Ins/VST3/Xenia.vst3sudo xattr -cr /Library/Audio/Plug-Ins/VST/Xenia.vstsudo xattr -cr /Library/Audio/Plug-Ins/Components/Xenia.componentsudo xattr -cr /Library/Audio/Plug-Ins/CLAP/Xenia.clapsudo xattr -cr /Library/Audio/Plug-Ins/LV2/Xenia.lv2
```

**Q: When controlling the plugin via my Master Keyboard, I get weird behavior such as volume changes / sound changes etc**

A: The microWAVE 2/XT hardware has control changes mapped to preset parameter changes. It is very likely that your Master Keyboard emits MPE control change messages that the microWAVE 2/XT doesn't understand. To fix this, either disable MPE on your Master Keyboard or filter them in your DAW

**Q: Why isn't there a Midi Learn function?**

A: The microWAVE 2/XT hardware already has plenty of control changes mapped to modify presets at runtime. Changing this behavior would mean that other external controllers or editors that are designed for the microWAVE 2/XT would stop functioning. Check the official microWAVE 2/XT documentation to see how the controllers are mapped

A2: We realize this is a very popular request and we are currently investigating a way to add this into our emulators.

**Q: How can I develop my own skin for the plugin?**

A: Right click anywhere in the plugin and export the currently loaded skin to disk. We provide a skinning capability, please see the blog post [HERE](//2025/08/19/rmlui-new-gui-rendering-engine-skinning-system/).

## NodalRed2x VST/AU/CLAP/LV2 FAQ (Clavia Nord Lead 2x)

This is the FAQ specific for the NodalRed2x plugin, which emulates the Clavia Nord Lead 2X (not to be confused with the Nord Lead 2).

**Q: On MacOS, plugins do not load because they are not properly signed**

A: Plugins on MacOS need to be signed manually after installation. To do so, we have included a script called 'macsetup_NodalRed2x.command' packaged with the MacOS plugin downloads. Simply extract the plugin archive, double-click the .command file, then copy the plugin to the desired plugin folder.

Alternatively, you can open a Terminal and execute the following commands for each format of the plugin you wish to install and use (if you have installed the plugins in a non-standard location or renamed the files, modify these commands to reflect those differences). An example for Vavra is shown below:

```
sudo xattr -cr /Library/Audio/Plug-Ins/VST3/NodalRed2x.vst3sudo xattr -cr /Library/Audio/Plug-Ins/VST/NodalRed2x.vstsudo xattr -cr /Library/Audio/Plug-Ins/Components/NodalRed2x.componentsudo xattr -cr /Library/Audio/Plug-Ins/CLAP/NodalRed2x.clapsudo xattr -cr /Library/Audio/Plug-Ins/LV2/NodalRed2x.lv2
```

**Q: When controlling the plugin via my Master Keyboard, I get weird behavior such as volume changes / sound changes etc**

A: The Nord Lead 2x hardware has control changes mapped to preset parameter changes. It is very likely that your Master Keyboard emits MPE control change messages that the Nord Lead 2x doesn't understand. To fix this, either disable MPE on your Master Keyboard or filter them in your DAW

**Q: Why isn't there a Midi Learn function?**

A: The Nord Lead 2x hardware already has plenty of control changes mapped to modify presets at runtime. Changing this behavior would mean that other external controllers or editors that are designed for the Nord Lead 2x would stop functioning. Check the official Nord Lead 2x documentation to see how the controllers are mapped

A2: We realize this is a very popular request and we are currently investigating a way to add this into our emulators.

## JE8086 VST/AU/CLAP/LV2 FAQ (Roland JP-8000 and soon JP-8080)

This is the FAQ specific for the JE8086 plugin, which emulates the Roland JP-8000 (and soon the JP-8080).

**Q: On MacOS, plugins do not load because they are not properly signed**

A: Plugins on MacOS need to be signed manually after installation. To do so, we have included a script called 'macsetup_je8086.command' packaged with the MacOS plugin downloads. Simply extract the plugin archive, double-click the .command file, then copy the plugin to the desired plugin folder.

Alternatively, you can open a Terminal and execute the following commands for each format of the plugin you wish to install and use (if you have installed the plugins in a non-standard location or renamed the files, modify these commands to reflect those differences). An example for Vavra is shown below:

```
sudo xattr -cr /Library/Audio/Plug-Ins/VST3/JE8086.vst3sudo xattr -cr /Library/Audio/Plug-Ins/VST/JE8086.vstsudo xattr -cr /Library/Audio/Plug-Ins/Components/JE8086.componentsudo xattr -cr /Library/Audio/Plug-Ins/CLAP/JE8086.clapsudo xattr -cr /Library/Audio/Plug-Ins/LV2/JE8086.lv2
```

**Q: When controlling the plugin via my Master Keyboard, I get weird behavior such as volume changes / sound changes etc**

A: The Roland JP-8000/8080 hardware has control changes mapped to preset parameter changes. It is very likely that your Master Keyboard emits MPE control change messages that the JP-8000/8080 doesn't understand. To fix this, either disable MPE on your Master Keyboard or filter them in your DAW

**Q: Why isn't there a Midi Learn function?**

A: The Roland JP-8000/8080 hardware already has plenty of control changes mapped to modify presets at runtime. Changing this behavior would mean that other external controllers or editors that are designed for the Nord Lead 2x would stop functioning. Check the official Roland JP-8000/8080 documentation to see how the controllers are mapped

A2: We realize this is a very popular request and we are currently investigating a way to add this into our emulators.

**Q: How can I develop my own skin for the plugin?**

A: Right click anywhere in the plugin and export the currently loaded skin to disk. We provide a skinning capability, please see the blog post [HERE](//2025/08/19/rmlui-new-gui-rendering-engine-skinning-system/).
