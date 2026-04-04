---
title: "Resampler Modes for TUS Plugins"
date: 2026-04-04
layout: post
---

Beginning with the 2.2.2 versions of our plugins, we have implemented and provided some additional resampling options.  These options can be found in the Settings Dialog under the DSP & Audio tab:

![Image](/images/posts/resampler-modes-for-tus-plugins/image1.png)

## MAME HQ vs Legacy Resampler

### Legacy (libresample)

  - Kaiser-windowed sinc with linear coefficient interpolation
  - 11-35 multiply-accumulates per sample depending on quality setting
  - Kaiser window (Beta=6), 90% Nyquist cutoff
  - ~70-100 dB stopband rejection
  - Interpolates between filter coefficients at runtime (introduces small phase error)

### MAME HQ (polyphase FIR)

  - Pre-computed polyphase filter bank — no runtime interpolation
  - Computes GCD of source/target sample rates to determine exact phase filters
  - Up to ~400 MACs per sample, but all from pre-computed tables (cache-friendly)
  - Hann-windowed sinc, cutoff at min(fs/2, ft/2)
  - 100+ dB stopband rejection
  - Fixed 5ms latency
  - Per-phase normalization preserves DC gain exactly

### What MAME HQ does better

  1. No interpolation error — every phase is pre-computed exactly, while legacy approximates between filter taps via linear interpolation
  2. Better anti-aliasing — 100+ dB stopband rejection vs ~70-100 dB, meaning less audible aliasing artifacts
  3. Exact phase filters — the polyphase decomposition means no phase distortion at any fractional delay
  4. Deterministic latency — fixed 5ms vs variable filter-dependent latency

### Trade-off

  MAME HQ uses more CPU (~400 MACs vs 11-35). The biggest audible difference would be on sample rate conversions with awkward ratios (e.g., 44.1kHz ↔ 48kHz) where the legacy resampler's linear coefficient interpolation introduces subtle artifacts that the polyphase approach eliminates entirely.
  
### MAME Lo-fi
  
  There's also a MAME Lofi mode (4-point cubic interpolation, ~4 MACs) for CPU-constrained scenarios that's still better than linear interpolation but significantly cheaper than either HQ mode. The lo-fi resampler uses 4-point filtering with a box filter for downsampling, and has almost negligible latency and very low CPU usage.  

  