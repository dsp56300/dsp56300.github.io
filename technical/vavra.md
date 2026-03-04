---
title: "Vavra (Waldorf microQ) Technical Information"
layout: default
permalink: /technical/vavra
---

All technical information we discovered on the architecture of the Waldorf microQ synthesizer is documented here. This information was gathered through PCB analysis, firmware disassembly, bootloader reverse engineering, and the process of building a cycle-accurate emulator. Much of the voice expansion protocol was uncovered by dumping the DSP bootloader and meticulously tracing the ESAI synchronization handshake.

## Hardware Overview

The Waldorf microQ (1999) is a virtual analog synthesizer that shares its core architecture with the Microwave II/XT series but adds significant advances in the DSP communication fabric. Like its predecessor, it is built around a **Motorola MC68331 microcontroller** and one or more **Motorola DSP56362 digital signal processors**. However, the inter-DSP bus was redesigned from the simpler ESSI ring topology of the Microwave II/XT to a sophisticated **ESAI network mode** bus, enabling much higher throughput and more flexible routing.

### Hardware Versions

- **1999 microQ** — desktop module, 1× DSP56362, 25 voices
- **microQ Keyboard** — keyboard variant, same internals
- **Voice Expansion** — up to 3× DSP56362, 75 voices total (optional expansion boards)

## Motorola MC68331 Microcontroller

The MC68331 is a 32-bit microcontroller from the Motorola 68000 family. It serves as the system controller:

- DSP initialization and firmware loading (including per-DSP firmware patching)
- MIDI processing via the on-chip QSM (Queued Serial Module)
- LCD display, LED control, button and encoder scanning
- Preset management and flash memory access
- Voice expansion board detection via HDI08 probe
- ESAI synchronization protocol orchestration during multi-DSP boot

### Memory Map

```
Address Range         Size     Description
─────────────────────────────────────────────
0x000000 - 0x03FFFF  256 KB   RAM (system memory)
0x100000 - 0x17FFFF  512 KB   ROM/Flash (firmware image)
0xFB000               –       HDI08 B (expansion DSP 1)
0xFC000               –       HDI08 C (expansion DSP 2)
0xFD000               –       HDI08 A (main DSP)
```

The flash memory is larger than the Microwave II/XT (512 KB vs 256 KB), reflecting the more complex firmware. The MC68k boots from ROM and copies the entire image into a RAM buffer for execution.

### Flash Memory

The synthesizer uses a **4 Mbit (512 KB) flash memory** chip (MX 29F400TTC-70, top boot block, AM29F-compatible). Contents include:

- MC68k firmware/operating system
- DSP bootstrap loader (loaded to P:$0700)
- DSP firmware code and data
- Per-DSP firmware patches (at P:$131A region)
- Factory and user preset storage

### Expansion Detection

The MC68k detects voice expansion boards at boot time by probing the HDI08 interfaces:

1. Read `HCR` (Host Control Register) from HDI08 B at `0xFB000`
2. Read `HCR` from HDI08 C at `0xFC000`
3. If a DSP is present, the read returns valid register data; if absent, the bus returns `0xFF`
4. The firmware checks the **IVR (Interrupt Vector Register)** byte — value `0x0F` indicates a valid DSP

The detection code resides at MC68k firmware offset `$89D46`.

## Motorola DSP56362

The DSP56362 is a 24-bit fixed-point digital signal processor from the Motorola DSP56300 family. It performs all audio synthesis — oscillators, filters, envelopes, effects, and mixing.

### PLL / Clock Configuration

The DSP's clock chain derives from a single external crystal:

```
External Crystal (EXTAL) = 33,868,800 Hz  (= 44100 × 768)
                          ↓
                   PLL Multiplier ×3
                          ↓
                   Core Clock = 101,606,400 Hz (~101.6 MHz)
```

The PLL is configured via the PCTL register value `$35000B`:
- **PDF (Pre-Divider)**: ÷1
- **MF (Multiplication Factor)**: 3×
- **Core clock**: 33.87 MHz × 3 = 101.6 MHz
- **ESAI bit clock**: Uses EXTAL directly = 33.87 MHz

### DSP Memory

| Region | Size | Description |
|--------|------|-------------|
| P (Program) Memory | 128K words | DSP code and bootloader |
| X (Data) Memory | External SRAM | Synthesis parameters, delay lines, buffers |
| Y (Data) Memory | External SRAM | Waveforms, tables, intermediate results |

Each word is 24 bits (3 bytes).

## Host Interface (HDI08) — MC68k ↔ DSP Communication

The MC68331 communicates with the DSP(s) through the **Host Data Interface (HDI08)**, a bidirectional 24-bit parallel port. The microQ uses different base addresses than the Microwave II/XT:

### HDI08 Address Map

| Interface | Address | Connected DSP | Role |
|-----------|---------|---------------|------|
| HDI08 A | `0xFD000` | DSP A (main) | Clock master, audio output |
| HDI08 B | `0xFB000` | DSP B (expansion 1) | Sync master via DMA |
| HDI08 C | `0xFC000` | DSP C (expansion 2) | Loopback relay |

Note the address differences from the Microwave II/XT (which uses `0xFC000`, `0xFD000`, `0xFE000`).

### Communication Protocol

The HDI08 protocol is the same as the Microwave II/XT:

- **TX (Host → DSP)**: MC68k writes 24-bit words; DSP reads from Host Receive register
- **RX (DSP → Host)**: DSP writes to Host Transmit register; MC68k reads from HDI08
- **Host Flags**: HF0/HF1 (host → DSP), HF2/HF3 (DSP → host)
- **HOTX/HORX**: Host Out TX / Host Out RX registers for data transfer

## DSP Boot Sequence

The microQ has a notably more complex boot sequence than the Microwave II/XT, involving a custom bootloader stage and per-DSP firmware patching.

### Phase 1: Hardware Bootstrap (DspBoot)

The DSP56362's built-in bootstrap ROM at `0xFFFF00` reads an initial program from the HDI08 port. The MC68k sends **181 words** that are loaded to P:`0x0000`:

1. MC68k sends `[length=181] [address=0x0000] [word₁] [word₂] ... [word₁₈₁]`
2. Bootstrap writes the words into P memory starting at address `0x0000`
3. Execution begins at `P:0x0000`

### Phase 2: Bootloader (Custom Command Handler)

The 181-word boot program at `P:0x0000` performs:

1. **Clear memory**: Zeroes out large regions of P, X, and Y memory
2. **Copy command handler**: Copies an embedded command handler routine to `P:$13B1`
3. **Jump to command handler**: Begins accepting memory transfer commands from the MC68k

The command handler at `P:$13B1` accepts these commands via HDI08:

| Command | Function |
|---------|----------|
| 0 | Write to P (Program) memory |
| 1 | Write to X (Data) memory |
| 2 | Write to Y (Data) memory |
| 3 | Write to X+Y paired (interleaved X word, Y word, X word, Y word...) |
| Any other | Jump to address $100 (start execution) |

This is similar to the Microwave II/XT command protocol but with the key difference that **any unrecognized command triggers a jump to `$100`**, rather than having an explicit "jump" command.

### Phase 3: Firmware Loading (Simultaneous Multi-DSP)

The MC68k loads firmware into all detected DSPs simultaneously:

1. **Main firmware**: ~11,050 words of P/X/Y data sent to all DSPs in parallel
2. **Per-DSP patches**: Each DSP receives a unique patch at `P:$131A` (approximately 20 words)

The per-DSP patches configure each DSP's role in the expansion network — this is how the same base firmware produces three different behaviors (clock master, sync master, sync slave).

### Phase 4: Execution Start

The MC68k sends the trigger value `$BE00` as a command. Since `$BE00` doesn't match commands 0–3, the command handler interprets it as "start execution" and jumps to `P:$100`, where the main synthesizer firmware begins.

### Boot Sequence Timeline

```
          MC68k                           DSP(s)
            │                               │
            │──── 181 words (DspBoot) ─────→│ Load to P:$0000
            │                               │ Clear memory
            │                               │ Copy handler → P:$13B1
            │                               │ Wait for commands...
            │                               │
            │──── Cmd 0: P memory ─────────→│ Write P data
            │──── Cmd 1: X memory ─────────→│ Write X data
            │──── Cmd 3: X+Y interleaved ──→│ Write X+Y data
            │──── Per-DSP patch at P:$131A ─→│ Apply role-specific code
            │                               │
            │──── $BE00 trigger ───────────→│ Jump to P:$100
            │                               │ ── Firmware running ──
```

## Audio Interface: ESAI (Enhanced Serial Audio Interface)

The microQ uses the **ESAI** rather than the ESSI used by the Microwave II/XT. The ESAI is a significantly more capable serial audio peripheral, supporting:

- Up to 12 serial data pins (6 TX, 6 RX) — vs. ESSI's 3 TX, 1 RX
- TDM (Time Division Multiplex) network mode with up to 32 time slots per frame
- Independent slot masking for TX and RX
- Programmable frame sync and clock generation
- Full DMA support for autonomous data transfer

### ESAI Clock Configuration

```
Crystal Oscillator: 33,868,800 Hz  (EXTAL = 44100 × 768)
                          │
                   ┌──────┴──────┐
                   │  ESAI TCCR  │
                   │  TPM = 0    │  (no prescaler division)
                   │  TDC = 31   │  (32 words per frame)
                   └──────┬──────┘
                          │
              Bit Clock = 33.87 MHz (= EXTAL, undivided)
              Word Clock = 33.87 MHz / 24 bits = 1,411,200 Hz
              Frame Rate  = 1,411,200 / 32 words = 44,100 Hz
```

### Timing Analysis

| Parameter | Value |
|-----------|-------|
| ESAI bit clock | 33,868,800 Hz |
| Bits per word | 24 |
| Words per frame | 32 (TDC = 31) |
| Active slots per frame | 20 (out of 32) |
| Frame rate | 44,100 Hz |
| Active data rate | 20 × 24 bits × 44,100 Hz = **21.17 Mbit/s** |
| DSP core cycles per ESAI word | 72 cycles |
| DSP core cycles per ESAI frame | 2,304 cycles |

### Slot Masking

The ESAI uses slot mask registers to select which of the 32 time slots are active:

- **TSMA** = `$FFFF` — slots 0–15 active (16 lower slots)
- **TSMB** = `$F` — slots 16–19 active (4 upper slots)
- **Total**: 20 active slots out of 32

The 20 active slots provide 20 channels of 24-bit audio at 44.1 kHz for inter-DSP communication. The remaining 12 slots are idle (transmit zeros).

### Why 20 Slots?

The 20 active ESAI slots correspond to the microQ's internal audio bus architecture. With 3 DSPs contributing audio to multiple output buses (main stereo, sub-outputs, effects sends, and internal mixing channels), 20 channels of inter-DSP bandwidth provide sufficient capacity for the complete audio mix.

## Voice Expansion: 3-DSP ESAI Sync Protocol

The microQ's voice expansion protocol is significantly more sophisticated than the Microwave II/XT's ESSI ring. Where the XT uses a simple ring topology with host-driven boot pumping, the microQ implements a **bus topology** with DMA-driven synchronization, per-DSP role assignment through firmware patching, and GPIO clock detection.

### Network Topology

Unlike the XT's ring (DSP→DSP→DSP→DSP), the microQ uses a **bus topology** where all three DSPs share the ESAI network:

```
       ESAI Network Bus (33.87 MHz bit clock, TDM 32 slots)
    ═══════════════╤══════════════════╤═══════════════════
                   │                  │                   │
              ┌────┴────┐       ┌────┴────┐        ┌────┴────┐
              │  DSP A  │       │  DSP B  │        │  DSP C  │
              │  Clock  │       │  Sync   │        │  Relay  │
              │  Master │       │  Master │        │  Slave  │
              └─────────┘       └─────────┘        └─────────┘
```

### Per-DSP Roles

Each DSP receives a unique firmware patch at `P:$131A` during boot that configures its role:

#### DSP A — Clock Master / Sync Slave

| Property | Value |
|----------|-------|
| HDI08 Address | `0xFD000` |
| Clock Role | **Master** — generates ESAI frame sync and bit clock |
| TCCR.TFSD | 1 (Frame Sync Direction = output) |
| TCCR.TCKD | 1 (Clock Direction = output) |
| ESAI TX | **Disabled** (no TSMA/TSMB set) |
| ESAI RX | Active on RX1 |
| Sync Mechanism | **Polls RX1** for magic value `$654300` |
| Sync Reporting | Writes magic value to HOTX (HDI08 → MC68k) when sync achieved |

DSP A is the clock master — it drives the ESAI bus clock and frame sync signals that all other DSPs use as their timing reference. However, it does **not** transmit audio data on the ESAI bus. Instead, it listens on RX1 for the sync magic value from DSP B.

#### DSP B — Sync Master (DMA-Driven)

| Property | Value |
|----------|-------|
| HDI08 Address | `0xFB000` |
| Clock Role | **Slave** — uses ESAI clock from DSP A |
| TCCR.TFSD | 0 (Frame Sync Direction = input) |
| TCCR.TCKD | 0 (Clock Direction = input) |
| ESAI TX | Active: TSMA=`$FFFF`, TSMB=`$F` (20 slots) |
| ESAI RX | Active on RX0 |
| Sync Mechanism | **DMA Channel 0**: X:`$0EC0` → ESAI TX1 register |
| DMA Buffer | X:`$0EC0`–`$113F`, 640 words, auto-refill |
| Magic Value | `$654300` at X:`$113F` (last word in DMA buffer) |

DSP B is the sync master — it uses DMA to continuously broadcast data on all 20 ESAI TX slots. The DMA buffer at X:`$0EC0` is 640 words (32 slots × 20 frames), with the magic value `$654300` placed at the very end. When the DMA cycles through the complete buffer, the magic value is transmitted, signaling to DSP A and DSP C that synchronization is achieved.

#### DSP C — Sync Slave / Loopback Relay

| Property | Value |
|----------|-------|
| HDI08 Address | `0xFC000` |
| Clock Role | **Slave** — uses ESAI clock from DSP A |
| TCCR.TFSD | 0 (Frame Sync Direction = input) |
| TCCR.TCKD | 0 (Clock Direction = input) |
| ESAI TX | Active: TSMA=`$FFFF`, TSMB=`$F` (20 slots) |
| ESAI RX | Active on RX1 |
| Sync Mechanism | **Polls RX1** for `$654300`, then enables DMA loopback relay |
| Relay Function | Re-broadcasts received data from RX to TX via DMA |

DSP C acts as a relay — once it detects the sync value from DSP B, it enables a DMA-driven loopback that retransmits received audio data. This ensures DSP A can receive the sync confirmation even though it's not directly connected to DSP B's TX output.

### Synchronization Handshake

The three DSPs perform a carefully choreographed sync handshake during boot:

```
Time ─────────────────────────────────────────────────────────→

DSP A (Clock Master):
  │ Enable ESAI clocks (TFSD=1, TCKD=1)
  │ Start polling ESAI RX1 for $654300...
  │ ................................................ Received! → Report to MC68k via HOTX

DSP B (Sync Master):
  │ Poll GPIO PDRC bit 4 for clock detect...
  │ ........ Clock detected! (PDRC.4 goes HIGH)
  │ Start DMA: X:$0EC0 → ESAI TX1 (640 words, auto-refill)
  │ DMA transmits buffer contents including $654300 at word 639

DSP C (Relay):
  │ Poll GPIO PDRC bit 4 for clock detect...
  │ ........ Clock detected! (PDRC.4 goes HIGH)
  │ Start polling ESAI RX1 for $654300...
  │ ................ Received! → Enable DMA loopback relay
  │ Now re-broadcasts DSP B's data (including $654300) → DSP A
```

### GPIO Clock Detection

DSP B and DSP C use GPIO pin **PDRC bit 4** (Port C, Data Register) to detect when DSP A has enabled the ESAI clock:

1. DSP A enables its ESAI transmitter (TFSD=1, TCKD=1) → drives the bus clock
2. The ESAI clock signal appears on the shared clock line
3. DSP B and DSP C poll PDRC bit 4 in a tight loop
4. When PDRC.4 transitions HIGH, the clock is running → proceed with sync

This GPIO-based handshake prevents DSP B and DSP C from attempting to use the ESAI before the clock is stable.

### The Magic Value: `$654300`

The magic value `$654300` is transmitted by DSP B via DMA and propagated by DSP C's relay:

- DSP B places `$654300` at X:`$113F` (last word of its 640-word DMA buffer)
- DMA auto-cycles through the buffer, transmitting all 640 words then restarting
- When the last word (`$654300`) is transmitted, it appears on the ESAI bus
- DSP C receives it on RX1, enables its relay, and re-broadcasts it
- DSP A receives it on RX1, confirms sync, and reports to the MC68k

Once synchronization is confirmed, the magic value is never used again — the ESAI bus carries only audio data during normal operation.

### DMA Configuration

| Parameter | DSP B | DSP C |
|-----------|-------|-------|
| DMA Channel | 0 | 0 |
| Source | X:`$0EC0` | RX → TX relay |
| Destination | M_TX1 (ESAI) | M_TX1 (ESAI) |
| Transfer Size | 640 words | Continuous |
| Mode | Auto-refill (circular) | Triggered |
| Direction | Memory → Peripheral | Peripheral → Peripheral |

## Comparison: microQ vs Microwave II/XT

| Feature | Microwave II/XT (Xenia) | microQ (Vavra) |
|---------|-------------------------|----------------|
| **DSP Model** | DSP56303 (ESSI) | DSP56362 (ESAI) |
| **Audio Rate** | 40 kHz | 44.1 kHz |
| **DSP Clock** | 10.24 MHz external | 33.87 MHz external (101.6 MHz core) |
| **Inter-DSP Bus** | ESSI (simple serial) | ESAI (advanced TDM) |
| **Bus Topology** | Ring: DSP→DSP→DSP→DSP | Bus: shared network |
| **Slots/Frame** | 8 | 32 (20 active) |
| **Data Rate** | 320 kHz (8× audio rate) | 21.17 Mbit/s |
| **Sync Mechanism** | Host-driven boot pump | DMA + GPIO + magic value |
| **Sync Value** | `$535400` | `$654300` |
| **Boot Protocol** | Direct register writes | DMA-driven autonomous |
| **Boot Firmware** | Same for all DSPs | Per-DSP patches at P:$131A |
| **HDI08 A Address** | `0xFE000` | `0xFD000` |
| **HDI08 B Address** | `0xFC000` | `0xFB000` |
| **HDI08 C Address** | `0xFD000` | `0xFC000` |
| **Voices (1 DSP)** | 10 | 25 |
| **Voices (3 DSPs)** | 30 | 75 |

The microQ represents a significant architectural evolution: the ESAI network mode provides over 60× the inter-DSP bandwidth compared to the XT's ESSI ring, while the DMA-driven sync protocol eliminates the need for host-driven boot pumping.

## Peripherals

### LCD Display

- **Type**: HD44780-compatible character LCD
- **Interface**: Connected via Port F GPIO pins
- **Control Signals**: RS (data/command), RW (read/write), Latch (enable)
- **Update**: Dirty flag mechanism triggers refresh only when content changes

### LEDs

Status LEDs controlled via a write latch:
- Power indicator, MIDI activity, and various mode indicators

### Buttons and Encoders

- Front panel buttons read via SPI through Port E chip selects
- Rotary encoders scanned at audio rate
- Power button on Port E, bit 5

## MIDI

MIDI is handled by the MC68k's on-chip **QSM (Queued Serial Module)** at the standard MIDI baud rate of 31.25 kbaud. The MC68k processes incoming MIDI messages and forwards relevant parameter changes to the DSP(s) via HDI08.

## Reverse Engineering Notes

### Bootloader Discovery

The microQ's custom bootloader was discovered by dumping DSP P memory after the initial 181-word bootstrap. Key findings:

- The bootloader at `P:$0000`–`P:$00B4` (181 words) is sent by the MC68k via HDI08
- It copies a command handler to `P:$13B1` and jumps to it
- The command handler protocol (commands 0–3, else jump) was decoded by tracing HDI08 traffic
- Per-DSP patches at `P:$131A` were identified by comparing firmware loads across the three DSPs

### ESAI Protocol Reverse Engineering

The 3-DSP ESAI sync protocol was reverse-engineered through:

1. **ASM disassembly analysis** of the 68k firmware (512 KB image)
2. **DSP bootloader dump** — extracting and analyzing the 181-word boot program
3. **Per-DSP patch comparison** — identifying the firmware differences that create the three roles
4. **DMA buffer analysis** — finding the magic value `$654300` at X:`$113F`
5. **GPIO trace** — identifying PDRC bit 4 as the clock detection signal
6. **ESAI register decode** — mapping TCCR/RCCR values to determine clock master/slave roles

### Key Differences from Microwave II/XT

- The microQ's ESAI is significantly more complex to emulate than the XT's ESSI
- DMA-driven sync means the emulator must support DMA↔ESAI TX integration
- GPIO clock detection requires modeling PDRC bit 4 state transitions
- The bus topology requires full ESAI network mode support (slot masking, TDM framing)
- Per-DSP firmware patching adds complexity to the boot sequence emulation
