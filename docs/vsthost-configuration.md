---
title: "VSTHost Configuration"
layout: default
permalink: /docs/vsthost-configuration
---

Here is our guide for using [VSTHost](https://www.hermannseib.com/english/vsthost.htm) to run the Emulator and control it using [VirusHC](https://www.mysteryislands-music.com/product/access-virushc/), you will also need [loopMIDI](http://www.tobias-erichsen.de/software/loopmidi.html) for this process

**The x64 version of VSTHost should be used**

**Step 1.** Install all of the programs needed from the text above

**Step 2.** Start loopMIDI and add two ports, I would advise copying our naming of the ports to make the rest of the instructions below easier

![](/images/pages/vsthost-configuration/Screenshot_206.png)

**Step 3.** Open VSTHost and head over to Devices>Midi in the Menu

![](/images/pages/vsthost-configuration/Screenshot_207.png)

**Step 4.** In the "Midi Input Devices" tab, select "loopMIDI VirusHC to Emu" and any other midi input devices you want to use such as MIDI Keyboards (TIP: Hold CTRL on your keyboard to select more than one)

![](/images/pages/vsthost-configuration/unknown.png)

**Step 5.** Switch to the "MIDI Output Devices" tab and select "loopMIDI Emu to VirusHC" from the list and then click OK to close the dialouge box

![](/images/pages/vsthost-configuration/unknown.png)

**Step 6.** Go to File>New Plugin and load both the **Emulator** and **VirusHC** into VSTHost seperatley

![](/images/pages/vsthost-configuration/Screenshot_209.png)

**Step 7.** Click the "Midi Input Filters" button only on "VirusHC" as indicated by the picture below

![](/images/pages/vsthost-configuration/Screenshot_219.png)

**Step 8.** You should now see a screen pop-up that looks like the image below, we need to de-select "All loaded MIDI Input Device" this can be done by holding "Ctrl" on your Keyboard and clicking once with your mouse

![](/images/pages/vsthost-configuration/unknown.png)

**Step 9.** With the same window open now switch to the "Midi Output Devices" tab and repeat the same process as Step 8, once done click "Apply" and then "OK"

![](/images/pages/vsthost-configuration/unknown.png)

**Step 10.** Open "VirusHC" and set the ports as indicated by the arrows in the image below

**IMPORTANT:** Select Input first then Output second


**Step 11.** Finished! Enjoy :)
