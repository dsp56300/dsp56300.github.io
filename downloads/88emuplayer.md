---
title: "88EmuPlayer Downloads"
layout: default
permalink: /downloads/88emuplayer
package: TheUsualSuspects-88emuPlayer-Standalone
downloads:
  - label: Windows
    icon: windows
    file: win64.zip
  - label: macOS
    icon: macos
    file: MacOS.zip
  - label: Linux x64
    icon: linux
    file: Linux_x86_64.zip
  - label: Linux aarch64
    icon: linux
    file: Linux_aarch64.zip
---

```
 █████╗  █████╗ ███████╗███╗   ███╗██╗   ██╗██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗ 
██╔══██╗██╔══██╗██╔════╝████╗ ████║██║   ██║██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
╚█████╔╝╚█████╔╝█████╗  ██╔████╔██║██║   ██║██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝
██╔══██╗██╔══██╗██╔══╝  ██║╚██╔╝██║██║   ██║██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗
╚█████╔╝╚█████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝██║     ███████╗██║  ██║   ██║   ███████╗██║  ██║
 ╚════╝  ╚════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
```
{: .ascii-banner}

<video class="banner-video" width="1048" height="360" autoplay muted loop playsinline poster="/images/pages/88emuplayer/intro.jpg">
  <source src="/images/pages/88emuplayer/intro.mp4" type="video/mp4">
</video>

88Emu emulates the hardware inside most Sound Canvas modules and related earlier sound generators, used for retro gaming and DTM. It runs the original firmware on emulated CPUs and sound chips, including the firmware's instrument selection, voice allocation, effects, MIDI handling and front-panel behavior. You supply the ROM images; they are not included.

88EmuPlayer is NOT a DAW-compatible plugin, but instead a standalone application for playing MIDI files and using those devices from a MIDI keyboard, sequencer or game. 88EmuCli uses the same emulation to render files to WAV offline using a command line interface, without having to wait for the song to play in real time.

Please read the provided [README](https://github.com/dsp56300/gearmulator/blob/main/doc/88emu_readme.md) and these instructions carefully to save our Discord Server from being overloaded with questions regarding the setup of the emulator.

> Is 88Emu ever gonna be released as DAW plugin?

Not at the moment, but we are working on it.

## <span class="inline-icon inline-icon-download" aria-hidden="true"></span>Emulator Downloads Links  

88EmuPlayer (Roland Sound Canvas and related synths), latest version<span data-release-version></span>:  
  
<div class="download-buttons" data-package="{{ page.package }}">
{%- for d in page.downloads %}
  <a class="btn download-btn" data-file="{{ d.file }}" href="https://github.com/dsp56300/gearmulator/releases"><span class="inline-icon inline-icon-{{ d.icon }}" aria-hidden="true"></span>{{ d.label }}</a>
{%- endfor %}
</div>

Other package formats (`.deb`, `.rpm`) are on the <a data-release-page href="https://github.com/dsp56300/gearmulator/releases">release page</a>.  
  
Older versions can be found on our [GitHub Releases Page](https://github.com/dsp56300/gearmulator/releases).

<script>
// Point the buttons at the newest release that actually carries these packages,
// so a new version needs no edit here. Until the lookup answers - or if it
// fails - the buttons fall back to the releases page.
(function () {
  var buttons = document.querySelector('.download-buttons[data-package]');
  if (!buttons) return;

  var prefix = buttons.getAttribute('data-package') + '-';
  var cacheKey = 'tus-release-' + prefix;
  var maxAge = 60 * 60 * 1000;

  function apply(release) {
    Array.prototype.forEach.call(buttons.querySelectorAll('[data-file]'), function (button) {
      var suffix = '-' + button.getAttribute('data-file');
      var asset = release.assets.filter(function (a) {
        return a.name.slice(-suffix.length) === suffix;
      })[0];
      // A release that skips a platform hides that button rather than 404ing
      if (asset) button.href = asset.url; else button.hidden = true;
    });
    Array.prototype.forEach.call(document.querySelectorAll('[data-release-page]'), function (link) {
      link.href = 'https://github.com/dsp56300/gearmulator/releases/tag/' + release.tag;
    });
    Array.prototype.forEach.call(document.querySelectorAll('[data-release-version]'), function (el) {
      el.textContent = ' ' + release.tag;
    });
  }

  try {
    var cached = JSON.parse(localStorage.getItem(cacheKey));
    if (cached && Date.now() - cached.time < maxAge) {
      apply(cached);
      return;
    }
  } catch (e) { /* no cache, ask GitHub */ }

  fetch('https://api.github.com/repos/dsp56300/gearmulator/releases?per_page=30')
    .then(function (response) {
      if (!response.ok) throw new Error(response.status);
      return response.json();
    })
    .then(function (releases) {
      var found = null;
      releases.some(function (release) {
        if (release.draft) return false;
        var assets = release.assets.filter(function (a) { return a.name.indexOf(prefix) === 0; });
        if (!assets.length) return false;
        found = {
          tag: release.tag_name,
          time: Date.now(),
          assets: assets.map(function (a) { return { name: a.name, url: a.browser_download_url }; })
        };
        return true;
      });
      if (!found) return;
      try { localStorage.setItem(cacheKey, JSON.stringify(found)); } catch (e) { /* not fatal */ }
      apply(found);
    })
    .catch(function () { /* keep the fallback links */ });
})();
</script>

**For further information, resources, discussion, and support of our plugins including the absolute latest beta versions (including the most current features and fixes) please visit our [Discord](https://discord.com/invite/WJ9cxySnsM).**

## Usage Guide

The zip files you can download contains two executable files/apps:
- **88emuPlayer**: Double click on this one if you want to use the software to play with a MIDI keyboard, playback MIDI files or use it to play retro video games;
- **88EmuCli**: if you want to quickly convert MIDI files into WAV files, without having to wait for the time of the song to pass in real time. This is a console application, so you probably want to run it from your terminal.

> <span class="inline-icon inline-icon-macos" aria-hidden="true"></span> **MacOS users:** macOS quarantines programs downloaded from the internet and can refuse to open 88emuPlayer or 88EmuCli the first time, saying it could not verify them. Open *System Settings → Privacy & Security*, scroll down to *Security*, click *Open Anyway* next to the message about the program, and confirm. This is needed once per program; for 88EmuCli, run it once in Terminal first so that the message appears. On macOS 14 and earlier, Control-clicking the app in Finder and choosing *Open* also works.

Once you run the application, you can select with device you want to emulate, like the SC-88 or the SC55mkII. Once you click on the device, a dialog will appear helping you correctly installing the necessary ROM files into the emulator.

You can then configure your MIDI inputs and audio outputs in Settings, open/drag MIDI files to be played into the MIDI player area, interact with the hardware buttons to configure the unit.

<img class="ui-screenshot" src="/images/pages/88emuplayer/ui_annotated.jpg" alt="88EmuPlayer User Interface">

**Please refer to the included [README](https://github.com/dsp56300/gearmulator/blob/main/doc/88emu_readme.md) for the rest of the options, features, gotchas, and configuration.**

### Usage for Retro-Gaming

You can use 88EmuPlayer for playing older games that use General MIDI or GS music. Experimental support for MT-32 and CM-64 compatible games is still partial (CM-32P only for now).

To achieve this you will need to route the MIDI output of your game or emulator (such as DOSBox, ScummVM or Neko Project) into 88EmuPlayer. If you are in a MacOS or Linux system, an option is available to create a "Virtual MIDI port", so that 88EmuPlayer can already show up as available option in the MIDI configuration of your emulator. If you are in a Windows based system, though, you will need to use a 3rd party software for that, such as [LoopBe1](https://www.nerds.de/en/loopbe1.html) or [loopmidi](https://www.tobias-erichsen.de/software/loopmidi.html).

## Asking for help

Please read our Support Guide which can be found [HERE](/docs/support-guide) to find out how and where to get support and assistance for our emulators.  

> PRO TIP: To avoid frustration, confusion, and running afoul of the rules, it is essential for all users to read the provided [README](https://github.com/dsp56300/gearmulator/blob/main/doc/88emu_readme.md) and our FAQ and Pinned Messages in the the various support channels in the Discord; answers to most of the common questions will be found in those locations.

### Notes about ROM/Firmware

Our emulator(s) work by executing the original code (ROM/firmware) of the synth it is emulating; it is not capable of generating audio on its own.  Our emulators are intended for use only by legitimate owners of the hardware synth(s).  As such, owners of these synths typically have access to such files through the manufacturer for users entitled to do so, usually in the form of installation packages or OS system updates.  We cannot legally provide you with this ROM/firmware as part of the emulator nor provide any assistance nor accept any responsibility or liability for any illegal usage of these emulators.  Per our **#rules** published on our Discord server, no discussion of how to acquire ROM/Firmware will be tolerated in our community and may result in a ban.

## Important Notice

88EmuPlayer and 88EmuCli are free software: you can redistribute them and/or modify them under the terms of the GNU General Public License, version 3, as published by the Free Software Foundation. They are distributed in the hope that they will be useful, but **without any warranty**, without even the implied warranty of merchantability or fitness for a particular purpose. `LICENSE.md` contains the full license. The GPL entitles you to the complete corresponding source code. The third-party components listed above keep their own licenses.

It is the sole responsibility of the user to operate this emulator within the bounds of all applicable laws. Using it with ROM images you are not legally entitled to own is forbidden by copyright law. If you are not legally entitled to use it, please stop using it. This package contains no ROM images.

Roland, Sound Canvas, GS and the Roland product names in this document are trademarks of Roland Corporation. Yamaha and XG are trademarks of Yamaha Corporation. 88EmuPlayer is an independent project and is not affiliated with, sponsored by or endorsed by Roland or Yamaha.
