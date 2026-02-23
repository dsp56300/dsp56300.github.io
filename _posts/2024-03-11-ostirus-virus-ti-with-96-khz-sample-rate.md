---
title: "OsTIrus / Virus TI with 96 KHz Sample Rate"
date: 2024-03-11
layout: post
---

We have discovered that the Virus TI DSP code can run with sample rates that are higher than what the hardware is capable of. We can use this to our advantage in OsTIrus because we are not limited to the hardware.

The hardware only supports up to two different sample rates:

- 44100 Hz (TI, TI2, Snow)

- 48000 Hz (TI, TI2)

However, the DSP code can handle the following sample rates, too:

- 32000 Hz

- 64000 Hz

- 88200 Hz

- 96000 Hz

## Adjusting the Sample Rate in OsTIrus

The following is implemented since OsTIrus version 1.3.8:

By default, OsTIrus uses either 44100 Hz or 48000 Hz, it automatically selects the best sample rate to match the host/DAW sample rate.

However, the sample rate can be overwritten manually in the advanced settings context menu:

![](/images/posts/ostirus-virus-ti-with-96-khz-sample-rate/image.png)

## Impact

Note that the DSPs run at the same clock rate no matter what sample rate is selected, running at a higher sample rate will reduce the maximum voice count.

Furthermore, we cannot say how much development has gone into this never-finished-feature. That a higher sample rate increases the quality of the generated audio is not guaranteed and is up to you to decide if its worth it.

## Technical Details

If the sample rate is modified in global settings, the external frequency at which various hardware runs is modified, too.

The external clock (EXTAL) that is fed to the DSPs is either ~11,29 MHz (44100 Hz \* 256) or ~12,288 MHz (48000 Hz \* 256). The DACs (Digital to Analog audio converters) are fed by the same clock and USB is too.

Running at a higher clock than 48 KHz would be too much for the USB interface, maybe that is why they limited it to a maximum of 48 KHz.

The DSP clock is 133 MHz by default and is dynamically overclocked based on patch complexity. If the external clock is changed, the DSP PCTL register is modified accordingly to set the DSP to 133 MHz again.

By using a logic analyzer, we figured out that the microcontroller sends two words to the DSPs to inform about the new sample rate:

```
44100 Hz: $f4f473 $40100048000 Hz: $f4f473 $401001
```

So:

- if the last byte is a $0, it is 44100 Hz,

- if the last byte is a $1, it is 48000 Hz

You can imagine that it was very tempting to see what the DSP does if we send something higher than $1 😊

It turned out that the DSPs react to higher numbers by adjusting the pitch, LFO rates etc. to match even higher sample rates. 👍

For higher sample rates, the DSP does not seem to expect a different EXTAL clock and still adjusts the DSP to 133 MHz. That is why we expect that higher sample rates result in less voices, but feel free to try! Also, you might be able to reach a higher voice count if you [overclock the DSP](//2024/03/01/advanced-setting-dsp-overclocking-underclocking/).
