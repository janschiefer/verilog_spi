## verilog_spi - A simple verilog implementation of the SPI protocol.

I wanted to learn verilog, so I created an own SPI implementation.

Goals:
- Easy to read, easy to understand.
- Simple and flexible implementation.

Features:
- SPI master / slave support
- all 4 modes (CPOL/CHPA)
- inverted data order support
- custom word size support

No external IP used. Should synthesize for all FPGAs.

Tested on Lattice ICE40UP5k.

Makefile builds bitstream for WebFPGA with yosys, nextpnr, icepack and compress-bitstream (from WebFPGA toolchain).
Extremely easy to modify for other FPGAs.

Licensed under the LGPL.

Happy synthesizing, 
Dr. med. Jan Schiefer.
