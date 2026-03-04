---
title: "Xenia (Microwave II/XT) Technical Information"
layout: default
permalink: /technical/xenia
---

All technical information we discovered on the architecture of the Waldorf Microwave II and Microwave XT synthesizer series is documented here. This information was gathered through PCB analysis, firmware disassembly, and the process of building a cycle-accurate emulator.

## Hardware Overview

The Waldorf Microwave II (1997) and Microwave XT (1998) are wavetable synthesizers built around a **Motorola MC68331 microcontroller** and one or more **Motorola DSP56303 digital signal processors**. The MC68331 handles all user-facing tasks — buttons, encoders, LCD display, MIDI — while the DSP56303 performs all audio synthesis.

The Microwave XT is an expanded version of the Microwave II with a larger front panel, more knobs, and a graphical display. Internally, they share the same core architecture and firmware structure.

### Hardware Versions

- **1997 Microwave II** — 1× DSP56303, 10 voices, rack-mount
- **1998 Microwave XT** — 1× DSP56303, 10 voices, keyboard
- **1998 Microwave XTk** — same as XT, keyboard variant
- **Voice Expansion** — up to 3× DSP56303, 30 voices total (optional expansion boards)

## Motorola MC68331 Microcontroller

The MC68331 is a 32-bit microcontroller from the Motorola 68000 family with integrated peripherals. It runs the synthesizer's operating system, handling:

- DSP initialization and firmware loading
- MIDI processing via the on-chip QSM (Queued Serial Module)
- LCD display and LED control
- Button/encoder scanning
- Preset management and flash memory access
- Voice expansion board detection and DSP coordination

### Memory Map

```
Address Range         Size     Description
─────────────────────────────────────────────
0x000000 - 0x01FFFF  128 KB   RAM (system memory, executable)
0x100000 - 0x13FFFF  256 KB   ROM/Flash (firmware image)
0xFC000               –       HDI08 B (expansion DSP 1)
0xFD000               –       HDI08 C (expansion DSP 2)
0xFE000               –       HDI08 A (main DSP)
```

The address space uses a 21-bit mask (`0x1FFFFF`), giving a total of 2 MB addressable range. The MC68331 boots from ROM at address `0x100100`.

### Flash Memory

The synthesizer uses a **4 Mbit (512 KB) flash memory** chip (MX 29F400TTC-70, AM29F-compatible, top boot block configuration). The flash contains:

- MC68k firmware/operating system
- DSP program code and data
- Factory presets
- User preset storage

At boot, the entire ROM image is copied into a runtime buffer in RAM, allowing the firmware to modify its own code/data space during operation (e.g., for preset storage or firmware updates).

## Motorola DSP56303

The DSP56303 is a 24-bit fixed-point digital signal processor from the Motorola DSP56300 family. It performs all audio synthesis — oscillators, filters, envelopes, effects, and mixing. Unlike the later DSP56362 used in the microQ (which features the ESAI peripheral), the DSP56303 uses the simpler **ESSI (Enhanced Synchronous Serial Interface)** for audio I/O.

### DSP Memory Layout

| Region | Size | Description |
|--------|------|-------------|
| P (Program) Memory | 128K words | DSP code space (`0x000000 - 0x01FFFF`) |
| X/Y (Data) Memory | 8M words (mapped) | External SRAM at bridged address `0x020000` |

Each 24-bit word is 3 bytes. The DSP56303's internal SRAM is complemented by external memory mapped via the Address Attribute Registers (AAR).

### PLL / Clock Configuration

The DSP's PLL is configured via the PCTL register during boot:

- **External clock**: 10.24 MHz crystal oscillator
- **Audio sample rate**: 40 kHz

This 40 kHz rate (rather than the more common 44.1 kHz or 48 kHz) is a distinctive characteristic of the Microwave II/XT series and directly affects the synthesizer's audio character.

## Host Interface (HDI08) — MC68k ↔ DSP Communication

The MC68331 communicates with the DSP(s) through the **Host Data Interface (HDI08)**, a bidirectional 24-bit parallel port. Each DSP has its own HDI08 interface at a dedicated memory-mapped address.

### HDI08 Address Map

| Interface | Address | Connected DSP | Role |
|-----------|---------|---------------|------|
| HDI08 A | `0xFE000` | DSP 2 (main) | Effects & final output |
| HDI08 B | `0xFC000` | DSP 0 (exp 1) | Voice generation |
| HDI08 C | `0xFD000` | DSP 1 (exp 2) | Additional voices |

In the standard single-DSP configuration, only HDI08 A is active. The expansion interfaces become active when voice expansion boards are detected.

### Communication Protocol

- **TX (Host → DSP)**: MC68k writes 24-bit words; DSP reads from its Host Receive register
- **RX (DSP → Host)**: DSP writes to Host Transmit register; MC68k reads from HDI08
- **Host Flags**: HF0/HF1 (host → DSP direction), HF2/HF3 (DSP → host, bidirectional)
- **Interrupts**: Configurable interrupts for RX data available and TX empty

The HDI08 is the sole communication channel between the microcontroller and DSPs — all MIDI data, parameter changes, preset loads, and control commands flow through it.

## DSP Boot Sequence

The initialization of the DSP follows a well-defined sequence:

### Phase 1: Hardware Bootstrap

The DSP56362 has a built-in bootstrap ROM at `0xFFFF00`. When released from reset, the bootstrap program reads words from the HDI08 port:

1. MC68k sends `[length] [address] [data words...]`
2. Bootstrap loads data into P memory at the specified address
3. Execution begins at the loaded address

For the Microwave II/XT, the initial boot code is loaded at P:`0x0100` (256 words).

### Phase 2: Firmware Loading

The boot code at `0x0100` implements a command handler that accepts memory transfer commands via HDI08:

| Command | Function |
|---------|----------|
| 0 | Write to P (Program) memory |
| 1 | Write to X (Data) memory |
| 2 | Write to Y (Data) memory |
| 3 | Write to X+Y paired (interleaved) |
| 4 | Jump to address (start execution) |

The MC68k sends the complete DSP firmware in chunks using these commands. Each chunk specifies: `[command] [address] [size] [data...]`

### Phase 3: Execution Start

After all firmware data is loaded, the MC68k sends a jump command (command 4) to start execution at the firmware's entry point.

## Audio Interface (ESSI)

The DSP56303 uses the **Enhanced Synchronous Serial Interface (ESSI)** for audio I/O — a simpler serial peripheral compared to the ESAI found in the DSP56362 used by the later microQ.

### ESSI0 — Audio DAC/ADC Interface

| Parameter | Value |
|-----------|-------|
| Sample Rate | 40 kHz |
| Word Size | 24-bit |
| Clock Source | 10.24 MHz external crystal |
| Input Channels | 2 (stereo audio in) |
| Output Channels | 4 (2× stereo out) |
| Clock Divider | ÷8 (10.24 MHz / 256 = 40 kHz) |

ESSI0 connects to the DAC/ADC converters for the physical audio inputs and outputs. The main DSP (index 2 with voice expansion, index 0 without) produces the final stereo mix on ESSI0 TX.

### ESSI1 — Inter-DSP Ring Bus (Voice Expansion Only)

When voice expansion is active, ESSI1 provides the high-speed data link between the 3 DSPs using a **ring topology**:

| Parameter | Value |
|-----------|-------|
| Data Rate | 320 kHz (8× audio rate) |
| Topology | Ring: DSP0 → DSP1 → DSP2 → DSP0 |
| Slots per Frame | 8 |
| Clock Divider | ÷1 (runs at base sample rate × 8) |

The ring routing is:
```
DSP 0 (exp1) ──ESSI1 TX──→ DSP 1 (exp2) ──ESSI1 TX──→ DSP 2 (main) ──ESSI1 TX──→ DSP 0
     ▲                                                                              │
     └──────────────────────────────────────────────────────────────────────────────┘
```

Each DSP's ESSI1 TX callback immediately forwards the transmitted frame to the next DSP's ESSI1 RX buffer, creating a low-latency audio pipeline.

## Voice Expansion

The Microwave II/XT supports expanding from 10 voices (single DSP) to **30 voices** (3 DSPs) via optional expansion boards. Each expansion board adds one additional DSP56303 processor.

### Expansion Detection

The MC68k detects expansion boards by probing the HDI08 interfaces at `0xFC000` (DSP 0) and `0xFD000` (DSP 1). If no expansion is present, only the main DSP at `0xFE000` is initialized.

### DSP Roles (3-DSP Configuration)

| Index | HDI08 | Role | Audio Interface |
|-------|-------|------|-----------------|
| 0 | B (`0xFC000`) | Expansion 1: Voice generation | ESSI0 RX (ext audio in) + ESSI1 ring |
| 1 | C (`0xFD000`) | Expansion 2: Additional voices | ESSI1 ring only |
| 2 | A (`0xFE000`) | Main: Effects & output | ESSI0 TX (stereo out) + ESSI1 ring |

All three DSPs receive the **same firmware** — they differentiate their roles at runtime based on which HDI08 port they're connected to.

### Synchronization: The Magic Value

During boot, the DSPs synchronize via a magic value **`0x535400`** transmitted around the ESSI1 ring. The main DSP (DSP 2) injects this value; it propagates through the ring (DSP 2 → DSP 0 → DSP 1 → DSP 2), and once received back, the ring is confirmed operational.

### Boot Pump Loop

The `initVoiceExpansion()` function implements a boot pump loop that actively drives the ESSI ring during initialization:

1. Prime each DSP's ESSI0 with 8 silence frames and ESSI1 with 64 frames (8× multiplier)
2. Drain all ESSI outputs to clear buffers
3. Enter a pump loop:
   - Read ESSI0 output from main DSP (audio samples)
   - Feed silence into ESSI0 RX (external audio input)
   - Route ESSI1 TX → RX between DSPs in the ring topology
4. Loop until the main DSP begins producing audio output (indicating boot complete)
5. Install real-time TX callbacks for ongoing ESSI1 ring routing

## Peripherals

### LCD Display

- **Size**: 40 × 2 characters (80 bytes total)
- **Custom Characters**: 8 programmable characters (5×8 pixel matrix each)
- **Interface**: Connected via the PIC (Programmable Interface Controller) through Port QS/GP
- **Update**: Dirty flag mechanism triggers UI refresh only when content changes

### LEDs

13 status LEDs controlled via the PIC:
- MIDI activity, Group 1–5, Sync, Play, Glide, Filter/Amp, Free Envelope, Wave 1, Wave 5

### Buttons

7 front-panel buttons: Play, Store, Recall, Compare, Undo, Utility, Power — read via SPI interface through the PIC.

### Encoders

The front panel features multiple rotary encoders for parameter editing, scanned by the MC68k at the audio rate.

## MIDI

MIDI is handled by the MC68k's on-chip **QSM (Queued Serial Module)** using the SCI (Serial Communication Interface) subsystem at a standard MIDI baud rate of 31.25 kbaud.

### Sysex Protocol (Waldorf Proprietary)

The Microwave II/XT uses a proprietary sysex protocol for preset, wave, and wavetable transfers:

| Message Type | ID | Size | Description |
|-------------|-----|------|-------------|
| Preset Bank | `0x50` | Variable | Bank preset data |
| Cartridge Bank | `0x54` | Variable | Cartridge preset data |
| Single Preset | `0x42` | 187 bytes | Individual preset (5B header + 180B data + 2B footer) |
| Single Wave | `0x44` | 139 bytes | Waveform data |
| Single Table | `0x45` | 264 bytes | Wavetable data |
| All Waves & Tables | `0x53` | 10,887 bytes | Bulk dump of all user waves/tables |

### Wavetable Memory

| Type | ROM Count | RAM Slots | First RAM Index |
|------|-----------|-----------|-----------------|
| Waves | 506 factory | 10 user | Index 246 |
| Tables | 32 factory | 32 user | Index 32 |

Each wave contains 128 samples (8-bit signed). Each wavetable references 64 wave indices.

## Reverse Engineering Notes

### Disassembly

Both the MC68k firmware and DSP code can be disassembled for analysis:

- **MC68k**: Load the 256 KB ROM into a disassembler with MC68000 processor selected. Entry point at `0x100100`.
- **DSP56303**: Extract DSP program from ROM using the boot command protocol. Load into disassembler with DSP56300 family selected.

The Gearmulator project includes a built-in disassembler for the DSP56300 instruction set that handles cross-references correctly (unlike some commercial tools which have issues with high-bit destination addresses in branch instructions).

### Key Observations

- **40 kHz sample rate** is unusual and gives the Microwave II/XT a distinctive frequency response ceiling (~20 kHz with steep anti-aliasing)
- The same firmware runs on all DSPs — voice allocation and role assignment are determined purely by hardware connections
- The ESSI ring bus for voice expansion is elegant in its simplicity: each DSP just forwards what it receives plus its own contribution
- The magic sync value `0x535400` is transmitted during boot and never again — ESSI1 carries only audio data during normal operation
