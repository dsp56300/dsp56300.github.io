---
title: "Osirus C Technical Information"
layout: default
permalink: /technical/osirus-c
---

All technical information we discovered on the architecture of the Access Virus synthesizer series is documented here.

See the `[access_virus](https://github.com/dsp563c/dsp563c-tools/tree/master/access_virus)` directory for a guide on how to use the tools and for additional information on specific hardware versions.

## [](https://github.com/dsp563c/dsp563c-tools#hardware-versions)Hardware Versions

- 1997 Virus A - 1 x Motorola DSP 56303, 1x SAB 80C535-N
- 1999 Virus B - 1 x Motorola DSP 56311, 1x SAB 80C535-N
- 2002 Virus C - 1 x Freescale DSP 56362, 1x SAF 80C515-L24N
- 2005 Virus TI - 2 x Freescale DSP 56367 - 2x150 MHz, 1x ST UPSD3212CV
- 2009 Virus TI2 - 2 x Freescale DSP 56367 - 2x150 MHz stock but overclocked

## [](https://github.com/dsp563c/dsp563c-tools#motorola-dsp563xx)Motorola DSP563xx

Each synthesizer has at least one 24-bit DSP (Motorola DSP563xx series) that performs the audio processing. Detailed information on the device and instruction set can be found in the corresponding Motorola User Manual and DSP56300 Family Manual.

## [](https://github.com/dsp563c/dsp563c-tools#i8051-microcontroller)i8051 microcontroller

Handling user inputs from knobs and showing data on an LED display is handled by an 8-bit MCU with the Intel i8051 instruction set. This microcontroller also takes care of initializing the DSP. The DSP is connected to the microcontroller via the Host Interface (HDI08).

## [](https://github.com/dsp563c/dsp563c-tools#flash-memory)Flash memory

The flash memory contains all the code and data the synthesizer needs to operate. All legacy models have 512K flash memory, the newer TI and TI2 models feature a total of 1M.

#### [](https://github.com/dsp563c/dsp563c-tools#contents)Contents

- i8051 operating system
- i8051 flash programming routines
- DSP563xx code (PRAM) and memory (XRAM, YRAM)
- Presets and other data

#### [](https://github.com/dsp563c/dsp563c-tools#layout)Layout

Flash memory is split up in banks of 32K (`0x8000`) bytes. This allows the memory to be directly addressable by the microcontroller, because the i8051 microcontroller only has 16 bits of address space for XRAM (`0x0 - 0xFFFF`).

The lower half of this address space (`0x0 - 0x8000`) always points to the first bank of the flash memory, while the upper half (`0x8000 - 0xFFFF`), can point to any other bank of the flash memory. This is achieved by a bank switching routine of the microcontroller.

The bank switching routine accepts one argument A, which can be mapped to a file offset in flash using: `offset = (A & 0xF0) << 11`. The low nibble is ignored. Note that we only verified this on legacy virus models (with 512K flash).

Example for `A = 0x10`: `(0x10 & 0xF0) << 11 == 0x8000`

#### [](https://github.com/dsp563c/dsp563c-tools#banks)Banks

The exact structure of the banks differs from synthesizer model to model, but for 512K flash it roughly looks like this:

```
[ bank 0 - 2  ] i8051 operating system code
[ bank 3 - 7  ] DSP563xx BootROM + chunks
[ bank 7      ] i8051 flash programming routines 
[ bank 8 - 15 ] preset data

```

## [](https://github.com/dsp563c/dsp563c-tools#execution-flow)Execution Flow

The i8051 microcontroller will go through the following initialization phases:

1. Flash memory is bank switched into the i8051 program address space.
2. i8051 execution starts at 0x0, which is an `ljmp RESET_0`.
3. RESET_0 routine will:
    - Perform generic initialization routines
    - Start DSP initialization (see below)
    - ... (TODO)

## [](https://github.com/dsp563c/dsp563c-tools#dsp-initialization)DSP initialization

The microcontroller will initialize the DSP by reading 24bit words from several banks in flash. For legacy models, the DSP data starts at bank 3 (offset 0x18000). For TI and TI2, the DSP data starts at bank 14 (offset 0x70000).

#### [](https://github.com/dsp563c/dsp563c-tools#bank-parsing)Bank parsing

Each bank is structured like this:

`[ 1 byte index ] [ 1 byte size1 ] [ 1 byte size2 ] [ 3 byte words ... ]`

The number of words to be read can be calculated as follows: `word_count = (size1 - 1) << 8 | size2`

With each bank read, the index will decrement. The last bank to be read has an index of 0. At the end of the last bank there is a string terminated with a null-byte that represents the version of the firmware.

#### [](https://github.com/dsp563c/dsp563c-tools#bank-data-stream)Bank data stream

The resulting data stream is structured like this (each element is one word / 24bits):

`[ bootrom_size ] [ bootrom_offset ] [ bootrom_data ... ] [ chunk_data ... ]`

This datastream is sent over the HDI08 port which is connected to the DSP. The built-in bootstrap program of the DSP running at `0xffff00` will read `bootrom_size` words and writes them to PRAM memory at offset `bootrom_offset`. (usually `0x100`). Execution will start there and the BootROM will be retrieving the remaining `chunk_data` from the same HDI08 port.

The assembly source code of the built-in bootstrap program can be found in Appendix A of the Motorola User Manual.

#### [](https://github.com/dsp563c/dsp563c-tools#dsp-chunk-data)DSP chunk data

The BootROM can be disassembled to see exactly how it processes the remaining chunk data, but the process is briefly described here.

Chunk structure: `[ cmd ] [ addr ] [ size ] [ words ... ]`

The `size` element indicates the number of words in the chunk.

The `addr` element indicates the destination address for the words.

##### [](https://github.com/dsp563c/dsp563c-tools#commands)Commands

```
000000: Write to P memory
000001: Write to X memory
000002: Write to Y memory
000003: Write to Y memory (split up each word in two 12-bit values)
000004: Jump to address (start execution)
```

## [](https://github.com/dsp563c/dsp563c-tools#reverse-engineering)Reverse Engineering

Both the microcontroller code and the DSP code can be disassembled using your favourite disassembler (we are using IDA Pro).

#### [](https://github.com/dsp563c/dsp563c-tools#microcontroller)Microcontroller

Just load the entire flash rom into IDA and select Intel 8051 as the processor type (and select the correct device name, see the hardware list). The RESET_0 routine should be visible (which is the main entrypoint).

Note that some routines are not recognized automatically (such as the flash programming ones). You can go to the correct offset and press `c` to instruct IDA to disassemble those.

#### [](https://github.com/dsp563c/dsp563c-tools#dsp-code)DSP Code

You can use the tools in [this](https://github.com/dsp563c/dsp563c-tools) repository to extract the DSP program from any Access Virus flash dump file.

It performs the BootROM method described above to extract the DSP memory and write it to a file. Then load up IDA and select dsp563xx as the processor type.

The entrypoint can be determined by looking at command 4. For the Virus TI, the entry point is $d0c.

We stumbled upon an issue with the cross-references in IDA. With the `jclr` instruction for example, IDA seems to ignore the high bits of the destination address, causing a wrongly displayed x-ref. Fortunately, we have written our own disassembler that works correctly. Our disassembler is part of the DSP emulation repository.

Some helpful scripts and configuration files are available in the `ida` directory.

Keep in mind that IDA Pro loads dsp563xx binaries using little endian, while the DSP563 itself uses big endian byte order. We included a tool be2le.py to make conversion easy :)

* * *

## Additional Information for Virus TI

The Virus TI is quite a drastic change in design compared to the previous generation of the series, named Virus A, B and C. The synthesis engine has more features compared to a Virus C. You can read about it everywhere, that's why we concentrate on the hardware differences here.

The most important hardware differences compared to a Virus C are:

- Two DSPs instead of one
- USB audio (1x stereo input, 3x stereo output)
- S/PDIF in and out

#### DSP Initialization

The DSP initialization is very similar to the previous generation (see above). To our surprise, both DSPs get the same code. So in theory, each one of the DSPs can do everything.

#### Load Balancing

We had lots of ideas how the load is distributed among two DSPs. However, as the serial communication lines for both DSPs are tied, there is no option for the microcontroller to talk to one DSP only. Everything that gets sent by the microcontroller is sent to both DSPs.

Our initial idea was that voices are evenly distributed across both DSPs, but it is even simpler:

- In Single Mode, only one DSP is used
- In Multi Mode, one DSP plays all odd parts, the other one all even parts

The microcontroller doesn't do anything here. Its on the DSP side, one DSP ignores Midi for all even parts and the other one ignores Midi for all odd parts, it is really as simple as that.

_So, as a conclusion, a tip for all TI owners: For maximum voice count, distribute your used presets in Sequencer Mode or Multi Mode equally on even and odd parts._

#### DSP Master & DSP Slave

As both DSPs run the same code, one might ask how a DSP knows if it is the first DSP or the second DSP?

This is achieved by the HACK pin, which is part of the HDI08 serial interface. This pin is used a GPIO and is low on one DSP and high on the other. The DSP checks the state of that pin by testing bit 15 of the HDR register during boot and initializes itself in a slightly different way.

We've chosen the following names for the two DSPs:

- HACK low = _**Master**_
- HACK high = _**Slave**_

The Master is used in Single Mode and plays all even parts in Multi Mode, i.e. part numbers 0, 2, 4, 6, …, the Slave plays parts 1,3,5,7, ….

#### Audio Routing

The used DSP 56367 has two audio interfaces, named ESAI and ESAI_1. Each audio interface has 6 output ports and 4 input ports, each port can work in multichannel mode.

Furthermore, each DSP has another audio interface named DAX, which can transmit AES/EBU & S/PDIF.

So this is plenty of audio I/O on DSP side.

On the hardware side, we have:

- 3x Analog Stereo Outputs
- 1x Analog Stereo Input
- 3x USB Stereo Output
- 1x USB Stereo Input
- 1x S/PDIF Output
- 1x S/PDIF Input

The S/PDIF out is driven by the Master DSPs DAX audio interface. We didn't investigate further here as it is not required for emulation.

Much more interesting (and more complex) are the analog in/outs and USB in/outs. As you can select any part to either output audio to one of the analog outs or to one of the USB outputs, we knew that there has to be some audio transfer between the two DSPs.  
After many hours of tracing on the PCB and decoding of how the ESAI pins are configured on the Master and the Slave, we came up with this list, which sums up how it works:

![](/images/pages/osirus-c/image-5.png)

- Parts on the Master that have their output set to one of the analog outputs are sent to the DAC by ESAI. This behavior is identical to the previous Virus series A, B and C
- Parts on the Slave that have their output set to USB are send to USB from ESAI directly. Similar to how the Master sends data to the analog outputs
- The second DSP audio interface ESAI_1 is used in a bidirectional way to transfer audio channels from one DSP to the other. Audio channels are transferred in the following cases:
    - The Master outputs to one of the USB outputs
    - The Slave outputs to one of the analog outputs
- The same bidirectional transfer is used for the inputs in the following cases:
    - The Master needs to process the USB input
    - The Slave needs to process the analog input

The ESAI audio interface has the following setup:

- 44,1 KHz or 48 KHz
- 2 channels per port

The ESAI_1 audio interface is setup in a different way:

- 88,2 KHz or 96 KHz
- 3 channels per port

The doubled data rate allows to transfer four ESAI ports on two ESAI_1 ports. However, the setup is not 2 channels but 3 channels, because:  
Additionally to the audio data, a clock signal is transmitted to synchronize the Slave to the Master. The Master injects the 24 bit value **_$edc987_** into the audio stream at regular intervals, which the Slave seems to use to synchronize its audio output to the Master. Upon reception of that clock, the Slave reports data back to the Master in return, which seems to be its current position in the audio buffer. In a wave editor, it looks like this (and sounds awful):

![](/images/pages/osirus-c/image-3.png)

A summary where each selected output ends up on the audio bus can be found below:

![](/images/pages/osirus-c/image-2.png)
