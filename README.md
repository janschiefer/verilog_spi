# verilog_spi - A simple verilog implementation of the SPI protocol.

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

## Usage:

Include these files in your own project:
* 	spi_module.v
*	clock_divider.v (onlyif you do not have a own clock divider mechanism for the SPI clock)
*	pos_edge_det.v
*	neg_edge_det.v

Module parameters

	parameter CPOL = 1'b0
	parameter CPHA = 1'b0
	parameter INVERT_DATA_ORDER = 1'b0
	parameter SPI_MASTER = 1'b1
	parameter SPI_WORD_LEN = 8 

Module instantiation

SPI master:

	spi_module 
	#( .SPI_MASTER (1'b1) )
	spi_master
	( .master_clock(Your master chip clock.),
	.SCLK_OUT(WIRE_TO_SCLK_OUTPUT_PIN),
  	.SCLK_IN(output from clock divider fpr SPI clock.), 
  	.SS_OUT(WIRE_TO_SS_OUTPUT_PIN),
  	.SS_IN(),
	.OUTPUT_SIGNAL(WIRE_TO_DATA_OUTPUT_PIN),
	.processing_word(Status: Is a word being processed?), 
	.process_next_word(Flag: Set to true to process the next word after the previous word has been processed.),
	.data_word_send(Data bits to send.),
	.INPUT_SIGNAL(WIRE_TO_DATA_INPUT_PIN),
	.data_word_recv(Data bits received.),
	.do_reset(Flag: Reset the module. Has to be set to 1 initially.),
	.is_ready(Status: Module intialized and ready?) );

SPI slave:

	spi_module 
	#( .SPI_MASTER (1'b0) )
	spi_slave
	( .master_clock(Your master chip clock.),
	.SCLK_OUT(),
  	.SCLK_IN(WIRE_TO_SCLK_INPUT_PIN), 
  	.SS_OUT(),
  	.SS_IN(WIRE_TO_SS_INPUT_PIN),
	.OUTPUT_SIGNAL(WIRE_TO_DATA_OUTPUT_PIN),
	.processing_word(Status: Is a word being processed?), 
	.process_next_word(Flag: Set to true to process the next word after the previous word has been processed.),
	.data_word_send(Data bits to send.),
	.INPUT_SIGNAL(WIRE_TO_DATA_INPUT_PIN),
	.data_word_recv(Data bits received.),
	.do_reset(Flag: Reset the module. Has to be set to 1 initially.),
	.is_ready(Status: Module intialized and ready?) );

THE SOFTWARE/HARDWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Happy synthesizing, 
Dr. med. Jan Schiefer.
