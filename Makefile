DEVICE 	   = --up5k
#DEVICE    = 5k
FOOTPRINT = sg48
header2="E+Fri_14_Jun_2019_09:00:38_PM_UTC+shastaplus"

testbench:
	# if build folder doesn't exist, create it
	mkdir -p "./test_data/"
	iverilog  -Wall -g2012 -o ./test_data/output.vvp clock_divider.v pos_edge_det.v neg_edge_det.v spi_module.v testbench.v
	vvp ./test_data/output.vvp > ./test_data/simulator.log
	vcdcat ./test_data/output.vcd > ./test_data/signals.log

fpga:
	# if build folder doesn't exist, create it
	mkdir -p "./build/"

	# synthesize using Yosys
	yosys -q -l  ./build/yosys.log -p "synth_ice40 -top fpga_top -json ./build/out.json" clock_divider.v pos_edge_det.v neg_edge_det.v spi2.v spi_module.v 

	nextpnr-ice40 -q -l ./build/nextpnr-ice40.log $(DEVICE) --placed-svg "./build/place-map.svg" --randomize-seed --placer heap --router router1 --freq 16 --promote-logic --opt-timing --sdf "./build/out.sdf" --pcf "./pinmap.pcf" --package $(FOOTPRINT) --json "./build/out.json" --asc "./build/out.asc"

	# Convert to bitstream using IcePack 
	icepack "./build/out.asc" "./build/out.bin"

	# Compress bitstream for flashing
	compress-bitstream "./build/out.bin" "./build/out.bin".h h  "$(header2)"
	compress-bitstream "./build/out.bin".h "./build/out.bin".c  c
	compress-bitstream "./build/out.bin".c "./build/out.bin".cbin  b
	compress-bitstream "./build/out.bin".cbin "./build/out.bin".db db
	cp ./build/out.bin.cbin ./bitstream.bin

clean:
	rm ./build/*

.PHONY: testbench clean
