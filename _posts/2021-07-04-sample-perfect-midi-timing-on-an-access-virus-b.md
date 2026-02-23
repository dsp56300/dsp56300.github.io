---
title: "Sample-perfect MIDI timing on an Access Virus B"
date: 2021-07-04
layout: post
---

One thing that was left to create a useful VST plugin was to work on the MIDI timing. This is now solved and works great, as you can hear in the video. 👍

If you want to know a little bit about the details, continue reading below the video. 👀


## Technical Background

In general, plugins work on audio in so called _blocks_. The host software, something such as Cubase, Ableton, etc., call the process() function of the plugin and request it to calculate _the next 256 samples of audio_. How many exactly depends on the block size (and also on some other conditions), but this is the concept in general.

What our test plugin did so far in this case is: It wrote all MIDI data to the HDI08 interface (serial DSP interface) and then processed the DSP until it has written enough samples to the ESAI interface (DSP audio interface).

This solution was not sufficient as you cannot pass a MIDI Note On including timing information to the DSP. Its just that a hardware never required to handle that information as it does not operate on blocks and any MIDI event, such as a Note On was just processed immediately.

To work around this problem, we did the following: We divide the processing block that is requested by the host software into chunks. If there is a block of 256 samples, but a MIDI event at position 100, we let the DSP process 100 samples of audio, then inject the MIDI data, then calculate the remaining 156 samples.
