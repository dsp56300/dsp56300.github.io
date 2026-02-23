---
title: "Advanced Setting: DSP overclocking/underclocking"
date: 2024-03-01
layout: post
---

Future emulator releases with versions 1.3.4 or higher allow to modify the DSP clock. This setting is part of a new section called _Advanced Settings_.

![](/images/posts/advanced-setting-dsp-overclocking-underclocking/image-12.png)

This setting directly affects host CPU utilization. If you run the DSP only at 50% of the desired speed, your host CPU utilization will be 50% of the default, if you run it at 200% the host CPU will use 200% of the default and so on.

The advantage of this is that users with older CPUs can lower the DSP clock to use the emulator without audio dropouts. Users with very fast CPUs can overclock the DSP to use more voices.

## Impact

Even though Osirus, OsTIrus and Vavra have a fixed maximum voice count, they all use dynamic voice stealing depending on patch complexity. For example, while Vavra has 25 voices max, you might be able to use less voices if the patch is very complex.

Dynamic voice stealing works by measuring the time the DSP has spent to process voices VS the fixed audio clock at which samples need to be transferred. If the DSP is running out of time, voices are cut to prevent audio drop outs.

This is where DSP underclocking / overclocking can help.

If the DSP is running at a lower frequency, the host CPU utilization is reduced, but less voices will be available.

On the other hand, if the DSP is running at a higher frequency, the total maximum voices can be used even with more complex patches. This does not mean that you can use more than 25 voices on Vavra, but you can use all 25 voices even on more complex patches. The same applies to Osirus and OsTIrus.
