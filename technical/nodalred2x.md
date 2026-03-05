---
title: "NodalRed2x (Nord Lead 2X) Technical Information"
layout: default
permalink: /technical/nodalred2x
---

All technical information we discovered on the architecture of the Clavia Nord Lead 2X synthesizer is documented here. This information was gathered through PCB analysis, firmware disassembly, and the process of building a cycle-accurate emulator.

## Hardware Overview

The Clavia Nord Lead 2X (2003) is a virtual analog synthesizer built around a **Motorola MC68331 microcontroller** and two **Motorola DSP56362 digital signal processors**. While architecturally similar to the Waldorf synthesizers in the Gearmulator suite (which also use MC68k + DSP56300-family chips), the Nord Lead 2X takes a distinctly different approach: it uses a **dual-DSP pipeline** rather than a single DSP with optional expansion, and runs at a remarkably high **98.2 kHz sample rate** — more than double the typical 44.1 kHz.

The Nord Lead 2X is a 4-part multitimbral synthesizer with slots A through D, each capable of running an independent synthesizer patch. The two DSPs split the voice workload — each processes half of the voices with a fixed assignment (no dynamic voice allocation). DSP A sends its audio to DSP B, which mixes in its own voices and produces the final 4-channel output to the DACs.

### Key Specifications

| Feature | Value |
|---------|-------|
| Manufacturer | Clavia (Sweden) |
| Year | 2003 |
| Microcontroller | Motorola MC68331 |
| DSPs | 2× Motorola DSP56362 |
| Sample Rate | 98,200 Hz |
| Audio Outputs | 4 channels (2× stereo) |
| Multitimbral Parts | 4 (Slots A–D) |
| ROM | 512 KB |
| RAM | 256 KB |
| Flash (I²C) | 64 KB |

## Motorola MC68331 Microcontroller

The MC68331 is the same 32-bit microcontroller from the Motorola 68000 family used by the Waldorf Microwave II/XT and microQ. It manages all non-audio tasks:

- DSP initialization and firmware loading via HDI08
- MIDI processing via the on-chip QSM (Queued Serial Module)
- Front panel I/O: 3 LCD segments, LEDs, 28 buttons, 25 knobs
- Keyboard scanning via 74HC374 latch
- I²C flash memory access for preset storage
- DSP reset control via GPIO

### Memory Map

```
Address Range         Size      Description
──────────────────────────────────────────────────
$000000 - $07FFFF     512 KB    ROM (firmware image)
$100000 - $13FFFF     256 KB    RAM (via CS8/CS9/CS10)
$200000               $800      HDI08 Both (write to both DSPs)
$200008               $800      HDI08 DSP A
$200010               $800      HDI08 DSP B
$202000               $800      Front Panel CS6 (buttons, LCD, LEDs)
$202800               $800      Front Panel CS4 (knob positions)
$203000               $800      Keyboard (via 74HC374 TSSOP)
```

The ROM and RAM are mapped into a single contiguous 2 MB buffer (`$000000`–`$1FFFFF`). The MC68k boots from ROM and begins execution at PC = `$0000C2`.

### Chip Select Configuration

| CS | Address | Size | Function |
|----|---------|------|----------|
| CS0 | `$200000` | `$800` | DSP interfaces (both) |
| CS4 | `$202800` | `$800` | Front panel knob readback |
| CS5 | `$203000` | `$800` | Keyboard interface |
| CS6 | `$202000` | `$800` | Front panel buttons/LCD/LEDs |
| CS8/9/10 | `$100000` | `$40000` | RAM A/B/both |
| CSBOOT | Boot ROM | — | Initial boot |

### GPIO Functions (Port GP)

| Bit | Function |
|-----|----------|
| 3 | DSP Reset |
| 4 | I²C SDA (flash data) |
| 5 | I²C SCL (flash clock) |
| 6 | DAC Reset |
| 7 | Sustain Pedal |

## Motorola DSP56362 — Dual DSP Pipeline

The Nord Lead 2X uses two DSP56362 processors that **split the voice workload** — each DSP processes half of the available voices. Unlike the Waldorf voice expansion approach (which adds identical DSPs and dynamically allocates voices), the Nord's two DSPs have a **fixed voice assignment** with no dynamic voice allocation. DSP A processes its voices and sends the resulting audio to DSP B, which mixes in its own voices and produces the final 4-channel output.

### DSP Memory

| Region | Size | Description |
|--------|------|-------------|
| P (Program) Memory | 16K words (`$4000`) | DSP code |
| X/Y (Data) Memory | 64K words (`$10000`) each | Synthesis data |
| External Memory | Mapped at `$8000` | External SRAM |

### Clock Configuration

```
External Clock = 3,333,333 Hz (≈10/3 MHz)

ESAI Base Clock = 196,400 Hz (= 98,200 × 2)
Audio Sample Rate = 98,200 Hz
```

The external clock frequency of 10/3 MHz was determined empirically — the schematic claims 1 MHz, but measurements showed 3.33 MHz. The clock source is cycle-based (derived from DSP instruction cycles rather than an external audio clock).

The ESAI base clock runs at **2× the audio sample rate** (196.4 kHz). This doubling is not because the DSPs synthesize at 2× — both DSPs process audio at 98.2 kHz. Instead, the doubled ESAI clock is needed to transfer **4 channels of audio** between DSP A and DSP B. Each ESAI frame carries a limited number of words, so running at 2× rate doubles the bandwidth, allowing all 4 output channels to be transmitted in real time.

### DSP A — Voice Processor (Chip U2)

DSP A processes half of the synthesizer's voices and transmits its audio output to DSP B via ESAI.

| Property | Value |
|----------|-------|
| Chip Designator | U2 (left on schematic) |
| ESAI TX Divider | 0 (fires every ESAI clock tick = 196.4 kHz) |
| Output | 4 words/frame → DSP B |
| HDI08 Address | `$200008` |

The TX divider of 0 means DSP A's ESAI transmitter fires at the full 196.4 kHz base clock rate, sending 4 audio words per frame (one word per output channel). Over two ESAI frames, this delivers one complete sample for all 4 channels at the 98.2 kHz audio rate.

### DSP B — Voice Processor + Final Mix (Chip U3)

DSP B processes the other half of the voices, mixes in the audio received from DSP A, and outputs the combined result to the DACs.

| Property | Value |
|----------|-------|
| Chip Designator | U3 (right on schematic) |
| ESAI TX Divider | 1 (fires every 2nd clock tick = 98.2 kHz) |
| ESAI RX Divider | 0 (receives at 196.4 kHz, matching DSP A's TX rate) |
| Input | 4 words/frame from DSP A at 196.4 kHz |
| Output | 4 channels (2× stereo) to DACs at 98.2 kHz |
| HDI08 Address | `$200010` |

DSP B's ESAI RX runs at the full 2× rate to keep up with DSP A's transmissions, while its TX runs at the 1× audio rate for DAC output.

### DSP A → DSP B Audio Routing

The audio pipeline between the two DSPs is managed by the emulator through a ring buffer and semaphore synchronization:

1. DSP A's ESAI TX callback fires at 196.4 kHz when a frame is ready
2. The 4-word output frame (DSP A's voice mix for all 4 channels) is popped from DSP A's ESAI output
3. The frame is reformatted as an ESAI RX frame and pushed to DSP B's ESAI input
4. DSP B mixes this with its own voice output to produce the final 4-channel audio
5. A semaphore (`m_semDspAtoB`) coordinates the handoff to prevent buffer overrun

## Host Interface (HDI08) — MC68k ↔ DSP Communication

The Nord Lead 2X has a unique triple HDI08 configuration:

| Interface | Address | Function |
|-----------|---------|----------|
| HDI08 DSP A | `$200008` | Individual communication with DSP A |
| HDI08 DSP B | `$200010` | Individual communication with DSP B |
| HDI08 Both | `$200000` | Simultaneous write to both DSPs |

The "Both" interface is write-only and sends data to both DSPs simultaneously. This is used during boot to load the same firmware into both DSPs in a single pass, and for parameter broadcasts that need to reach both processors.

### Communication Protocol

- **TX (Host → DSP)**: MC68k writes 24-bit words; DSP reads from Host Receive register
- **RX (DSP → Host)**: DSP writes to Host Transmit register; MC68k reads from HDI08
- **Host Flags**: HF2/HF3 from DSP mapped to ISR bits for MC68k status reads
- **TRDY**: Always enabled — the MC68k is always ready to receive data
- **IRQ Injection**: MC68k can inject interrupt vectors directly into the DSP for immediate execution

### Boot Detection

Each DSP's HDI08 monitors for the first TX write from the DSP. When detected, this signals that the DSP has finished executing its bootstrap code and is ready for normal operation. The HDI08 callback then switches from the boot handler to the normal communication handler.

## DSP Boot Sequence

The Nord Lead 2X boot sequence is simpler than the Waldorf synths because the firmware is identical for both DSPs:

### Phase 1: Hardware Bootstrap

1. MC68k deasserts DSP reset (Port GP, bit 3)
2. Both DSP56362s begin executing their built-in bootstrap ROM at `$FFFF00`
3. Bootstrap reads initial program words from HDI08

### Phase 2: Firmware Loading

The MC68k loads firmware through the "Both" HDI08 interface at `$200000`, sending the same program to both DSPs simultaneously. The boot loader (`DspBoot` class) handles the transfer protocol.

### Phase 3: Boot Completion

When a DSP writes its first word to the HDI08 TX register, the `onDspBootFinished()` callback fires:
1. The HDI08 handler switches from boot mode to normal mode
2. A dedicated DSP thread is created for the DSP
3. Both DSPs must complete boot before the hardware reports ready

### Phase 4: Audio Sync

Once both DSPs are booted, the ESAI callbacks are active and the audio pipeline begins:
- The MC68k thread synchronizes to the ESAI frame rate
- UC cycles are budgeted based on elapsed ESAI frames
- A halt/resume mechanism prevents the DSPs from running too far ahead

## Audio Interface (ESAI)

Both DSPs use the **ESAI (Enhanced Serial Audio Interface)** — the same peripheral type as the Waldorf microQ's DSP56362, but configured quite differently.

### ESAI Configuration

| Parameter | Value |
|-----------|-------|
| Audio Output Channels | 4 (2× stereo pair) |
| Audio Input Channels | 0 (no external audio input) |
| Sample Rate | 98,200 Hz |
| ESAI Base Clock | 196,400 Hz (2× audio rate for 4-channel bandwidth) |
| Frame Sync Rate | 16 (power of 2) |
| DSP Halt Threshold | 32 frames |

The 98.2 kHz sample rate gives the Nord Lead 2X a theoretical Nyquist frequency of ~49.1 kHz, well above the audible range and providing excellent anti-aliasing characteristics.

### Audio Output Format

The 4 output channels are interleaved in the ESAI output:

| Channel | Index | Description |
|---------|-------|-------------|
| 0 | Left A | Main stereo left |
| 1 | Right A | Main stereo right |
| 2 | Left B | Sub stereo left |
| 3 | Right B | Sub stereo right |

The output mode (how the 4 slots map to the stereo pairs) is configurable via the `OutModeABCD` multi parameter.

## Flash Memory (I²C EEPROM)

The Nord Lead 2X uses a **64 KB I²C EEPROM** for non-volatile patch storage, accessed through bit-banged I²C on Port GP:

| Signal | Port GP Bit | Function |
|--------|-------------|----------|
| SDA | Bit 4 (OC2) | Data line |
| SCL | Bit 5 (OC3) | Clock line |

The I²C master implementation supports both read and write operations with full acknowledgment handling. The flash stores user presets and system settings that persist across power cycles.

## Front Panel

### Display

The Nord Lead 2X uses **3 seven-segment LCD displays** (not a character LCD like the Waldorf synths). The displays are controlled via the CS6 interface at `$202000` through three LED latch registers:

| Register | Offset | Controls |
|----------|--------|----------|
| LED Latch 8 | `+$08` | Display data byte |
| LED Latch 10 | `+$0A` | LCD 2 enable (bit 7) + LEDs |
| LED Latch 12 | `+$0C` | LCD 0/1 enable (bits 6-7) + LEDs |

### Buttons

28 front panel buttons organized in 4 groups of 8, read via CS6:

| Group (Offset) | Buttons |
|----------------|---------|
| `+$00` | Trigger, Oct+, Oct−, Up, Down |
| `+$02` | Assign, Perf, Osc2 Keytrack, Osc Sync, Filter Type, Filter Velo, Filter Dist, Osc2 Shape |
| `+$04` | Distortion, Arp, Store, Mod Env Dest, LFO1 Shape, LFO1 Dest, LFO2 Shape, Osc1 Shape |
| `+$06` | Slot A, Slot B, Slot C, Slot D, Poly, Unison, Portamento, Mod Wheel Dest (= Shift) |

### Knobs

25 analog knobs read via the CS4 interface at `$202800`. The MC68k selects a knob by writing to CS6 (setting `m_selectedKnob`), then reads the 8-bit position value from CS4:

| Range | Knobs |
|-------|-------|
| `$38`–`$3F` | Osc1 FM, Portamento, LFO2 Rate, LFO1 Rate, Master Volume, Mod Env Amount, Mod Env D, Mod Env A |
| `$58`–`$5F` | Amp Env D, Filter Freq, Filter Env A, Amp Env A, Osc Mix, Osc2 Fine, LFO1 Amount, Osc PW |
| `$68`–`$6F` | Amp Gain, Filter Env R, Amp Env R, Filter Env Amount, Filter Env S, Amp Env S, Filter Reso, Filter Env D |
| `$70`–`$74` | Pitch Bend, Mod Wheel, Expression Pedal, LFO2 Amount, Osc2 Semi |

### Keyboard

The keyboard interface is at CS5 (`$203000`), connected through a **74HC374 TSSOP latch**. Keyboard interrupts arrive via Port F. The emulator keeps Port F at `$FF` to prevent the MC68k from spin-looping while waiting for keyboard IRQs.

## MIDI

MIDI is handled by the MC68k's on-chip **QSM (Queued Serial Module)** at the standard MIDI baud rate of 31.25 kbaud.

### Sysex Protocol (Clavia Proprietary)

| Byte | Value | Description |
|------|-------|-------------|
| 0 | `$F0` | Sysex start |
| 1 | `$33` | Manufacturer ID (Clavia) |
| 2 | Device ID | Default: `$0F` |
| 3 | `$04` | Product ID (Nord Lead 2X) |
| 4 | Message Type | Bank / command identifier |
| 5 | Message Spec | Program number |
| 6+ | Data | Nibble-packed parameters |
| Last | `$F7` | Sysex end |

### Patch Dump Formats

| Type | Size | Description |
|------|------|-------------|
| Single Dump | 139 bytes | 66 params × 2 nibbles + 7 byte container |
| Single + Name | 149 bytes | Single dump + 10-byte ASCII name |
| Multi Dump | 716 bytes | 4 singles + 90 multi params + container |
| Multi + Name | 726 bytes | Multi dump + 10-byte ASCII name |

### Single Banks

| Bank | Dump ID | Request ID |
|------|---------|------------|
| Edit Buffer | `$00` | `$0E` |
| Bank A | `$01` | `$0F` |
| Bank B | `$02` | `$10` |
| Bank C | `$03` | `$11` |
| Bank D | `$04` | `$12` |

Total: 10 single banks × 99 programs each, plus 4 multi banks × 99 programs each.

### Parameter Format

Each single patch contains 66 parameters stored as nibble pairs (2 bytes per parameter = 132 data bytes). Unpacking:
```
value = (byte[offset] & 0x0F) | (byte[offset + 1] << 4)
```

### MIDI CC Mapping

All 66 single parameters are accessible via MIDI Continuous Controller messages. Key mappings include:

| CC | Parameter |
|----|-----------|
| 7 | Gain |
| 74 | Filter Cutoff |
| 42 | Resonance |
| 5 | Portamento |
| 73 | Amp Envelope Attack |
| 72 | Amp Envelope Release |
| 8 | Oscillator Mix |
| 70 | FM Depth |
| 80 | Distortion |

## ROM Validation

The firmware ROM is a single 512 KB binary file. Validation is performed by searching for the magic signature:

```
'n', 'r', '2', 0x00, 'n', 'L', '2', 0x00
```

This 8-byte sequence can appear at any offset within the ROM. If found, the ROM is considered valid.

## MC68k ↔ DSP Synchronization

The emulator uses ESAI frame timing to synchronize the MC68k thread with the DSPs:

1. The MC68k runs in its own thread at highest priority
2. ESAI frame callbacks from DSP B increment a frame counter
3. The MC68k budgets its instruction cycles based on elapsed ESAI frames:
   ```
   ucCyclesPerFrame = systemClockHz / sampleRate
   remainingCycles += ucCyclesPerFrame × esaiFramesDelta
   ```
4. If the DSPs run more than 32 frames ahead, they are halted until the MC68k catches up
5. When the MC68k exhausts its cycle budget, it waits for the next ESAI frame notification

This synchronization ensures accurate timing between the microcontroller and DSPs, which is critical for sample-accurate MIDI processing.

## Architectural Comparison

| Feature | Nord Lead 2X | Waldorf MW II/XT | Waldorf microQ |
|---------|-------------|------------------|----------------|
| **DSP Model** | DSP56362 (×2) | DSP56303 (×1–3) | DSP56362 (×1–3) |
| **DSP Topology** | Fixed dual (split voices) | Optional ring expansion | Optional bus expansion |
| **Sample Rate** | 98.2 kHz | 40 kHz | 44.1 kHz |
| **Audio Interface** | ESAI | ESSI | ESAI |
| **Voice Expansion** | No (fixed dual DSP) | Yes (up to 3 DSPs) | Yes (up to 3 DSPs) |
| **Multitimbral** | 4 parts (Slots A–D) | — | — |
| **Manufacturer** | Clavia (Sweden) | Waldorf (Germany) | Waldorf (Germany) |
| **Sysex Mfr ID** | `$33` (Clavia) | `$3E` (Waldorf) | `$3E` (Waldorf) |
| **Flash Storage** | I²C EEPROM (64 KB) | On-chip flash (512 KB) | On-chip flash (512 KB) |
| **Display** | 3× seven-segment LCD | Character LCD | Character LCD |
| **External Clock** | 3.33 MHz | 10.24 MHz | 33.87 MHz |

## Reverse Engineering Notes

### Dual-DSP Discovery

The dual-DSP architecture was identified through:
- Two separate HDI08 interfaces at `$200008` and `$200010`
- A combined "Both" interface at `$200000` used during boot
- Separate ESAI configurations: DSP A at 2× rate, DSP B with rate stepping
- Audio data flowing from DSP A → DSP B via ring buffer in the emulator

### Clock Measurement

The external clock was a point of confusion: the schematic labeled it as 1 MHz, but empirical measurement during emulator development revealed 3,333,333 Hz (10/3 MHz). This was confirmed by matching the emulator's audio output rate to the expected 98.2 kHz.

### Seven-Segment LCD

Unlike the Waldorf synths which use standard HD44780-compatible character LCDs, the Nord Lead 2X uses three individual seven-segment displays. This required custom rendering in the emulator's plugin UI, including text scrolling animation support.
