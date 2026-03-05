---
title: "How the Emulator Works"
layout: default
permalink: /technical/how-it-works
---

```
██╗  ██╗ ██████╗ ██╗    ██╗    ██╗████████╗
██║  ██║██╔═══██╗██║    ██║    ██║╚══██╔══╝
███████║██║   ██║██║ █╗ ██║    ██║   ██║
██╔══██║██║   ██║██║███╗██║    ██║   ██║
██║  ██║╚██████╔╝╚███╔███╔╝    ██║   ██║
╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝     ╚═╝   ╚═╝
██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗███████╗
██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝██╔════╝
██║ █╗ ██║██║   ██║██████╔╝█████╔╝ ███████╗
██║███╗██║██║   ██║██╔══██╗██╔═██╗ ╚════██║
╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗███████║
 ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
```

# How the Emulator Works

Gearmulator is not a software synthesizer — it is a **hardware emulator**. Rather than recreating synth algorithms in new code, we emulate the original integrated circuits (DSPs, microcontrollers) at the chip level and run the **original, unmodified firmware** from the real hardware. The result is an emulation that produces bit-exact output compared to the original device.

This page explains the technical architecture that makes this possible and how the different components interact.

## The Emulated Device

At the core of each plugin is a virtual copy of the original hardware:

- **DSP chips** (e.g. Motorola DSP 56300 family) are emulated instruction-by-instruction, including all peripherals (timers, serial ports, DMA, host interfaces)
- **Microcontrollers** are either fully emulated (e.g. Motorola 68000 for the Nord Lead, Hitachi H8S for the Roland JP-8000) or reimplemented in C++ where full emulation is not necessary (e.g. the Access Virus i8051)
- **The original firmware ROM** is loaded and executed exactly as it would run on the real chip — we never modify, patch, or extend it

This means the emulated device **behaves identically to the real hardware**, including any quirks, bugs, or undocumented behavior present in the original firmware. We cannot add new features to the synthesizer engine itself, because that would require changing the firmware. Our goal is **exact reproduction**, not enhancement.

## The User Interface as a MIDI Controller

The plugin's graphical interface is not directly connected to the synthesis engine. Instead, it operates as a **MIDI controller** — exactly like a hardware control surface would interact with the real synthesizer:

- Turning a knob in the UI sends a **MIDI Control Change** or **SysEx message** to the emulated device
- The emulated device processes these messages through its firmware, just as it would process messages from a physical MIDI cable
- Parameter changes from the device are sent back as MIDI messages and reflected in the UI

This architecture means the UI and the emulated device are fully decoupled. The device does not know or care whether it is receiving MIDI from our editor, a DAW, or an external MIDI keyboard — it processes everything the same way.

## Custom MIDI Extensions

While standard MIDI covers parameter changes and preset management, the original hardware has features that were never designed to be communicated over MIDI — things like LCD screen content, LED states, and front panel indicators. To bridge this gap, we use **custom SysEx messages** that extend the communication between the emulated device and the editor:

- **LCD content** — On synths with character displays (e.g. Waldorf microQ, Roland JP-8000), the emulated microcontroller sends the display buffer to the editor via custom SysEx, allowing us to render the original LCD content in the plugin UI
- **LED states** — Front panel LED bitmaps are transmitted so the UI can show the same indicator states as the real hardware
- **LFO phases** — The DSP timer registers that drive the hardware's LFO LEDs are read and forwarded to the UI, enabling the pulsing LFO indicators and the breathing logo animation (see the Virus technical page for details)
- **Button and encoder events** — The UI can simulate front panel button presses and encoder turns, sent as custom messages to the emulated microcontroller

These custom messages are **emulator-only extensions** — they are not part of the original MIDI protocol of any device and are never sent to the DAW or external MIDI ports.

## Preset Management

On the original hardware, presets are stored in ROM or flash memory and loaded into an **edit buffer** when selected. The edit buffer is the working copy that the DSP uses to produce sound.

In the emulator, the [Patch Manager](/docs/patch-manager) takes a different approach for most emulations:

- Instead of loading presets from the device's ROM banks, the Patch Manager **sends the complete preset data as a SysEx dump directly to the edit buffer**
- This means the device's internal ROM preset storage is largely bypassed — presets come from the Patch Manager's database on disk
- The device firmware processes these SysEx dumps exactly as it would a dump received from a MIDI cable, so the loading behavior is identical to the real hardware
- This approach allows managing thousands of presets from various sources without being limited to the device's internal bank structure

## MIDI Routing Matrix

A **MIDI routing matrix** controls how MIDI events flow between four endpoints:

| Endpoint | Description |
|----------|-------------|
| **Device** | The emulated synthesizer hardware |
| **Editor** | The plugin's graphical user interface |
| **Host** | The DAW (for automation, MIDI input from tracks) |
| **Physical** | External MIDI ports (hardware controllers, other devices) |

The matrix allows selective routing of different MIDI event types (notes, CCs, SysEx, program changes, etc.) between any combination of these endpoints. For example:

- **Host → Device**: MIDI notes and CCs from DAW tracks reach the synth
- **Device ↔ Editor**: Bidirectional parameter sync between UI and synth
- **Physical → Device**: External MIDI keyboards can play the emulated synth
- **Editor → Host**: Parameter changes in the UI are reported back for DAW automation

Internal messages (LCD content, LFO phases, LED states) are routed exclusively between Device and Editor and are never forwarded to the Host or Physical ports.

Users can customize the routing matrix to fit their setup — for example, disabling note routing from the editor to avoid double triggers, or enabling physical MIDI output to drive external hardware alongside the emulation.

## Rendering

The plugin UI is built with [JUCE](https://juce.com/) as the audio plugin framework and [RmlUi](https://mikke89.github.io/RmlUiDoc/) as the UI rendering engine. RmlUi uses an HTML/CSS-like markup language to define the interface layout and styling:

- Plugin skins are defined in `.rml` (structure) and `.rcss` (styling) files
- RmlUi renders to an OpenGL surface within the JUCE plugin window
- This approach enables fully skinnable UIs — the community can create custom skins using familiar web-like markup
- Multiple skins per emulation are supported, selectable at runtime

## Summary

```
┌─────────────────────────────────────────────────────────┐
│                      DAW (Host)                         │
│                    MIDI / Automation                    │
└──────────────────────┬──────────────────────────────────┘
                       │
              ┌────────▼────────┐
              │  MIDI Routing   │◄────── Physical MIDI Ports
              │     Matrix      │
              └───┬─────────┬───┘
                  │         │
       ┌──────────▼──┐ ┌───▼──────────┐
       │  Emulated   │ │   Editor UI  │
       │   Device    │ │  (JUCE +     │
       │             │ │   RmlUi)     │
       │ ┌─────────┐ │ │              │
       │ │   DSP   │ │ │  Knobs,      │
       │ │Firmware │ │ │  LCD, LEDs,  │
       │ └─────────┘ │ │  Patch Mgr   │
       │ ┌─────────┐ │ │              │
       │ │  MCU /  │ │ └──────────────┘
       │ │  Host   │ │
       │ │Interface│ │
       │ └─────────┘ │
       │     ▼       │
       │   Audio     │
       │   Output    │
       └─────────────┘
```

The key insight is that **everything runs through MIDI**. The emulated device is a black box running original firmware — the editor talks to it in exactly the same language that the real hardware understands. This is what makes the emulation authentic: we are not approximating the synthesizer's behavior, we are running the actual code that produces it.
