Simple 68000 based 16-bit computer. Just for fun


Folder Structure:

/rtl/verilog
	Glue logic in Verilog HDL. This replaces a earlier schematic that was using 74 series logic for generating control signals,
	address decoding, dtack circuity, watchdog monitor and vectored interrupts. Using a CPLD for glue logic eliminates alot of chips,
	and allows for easily updating or fixing the circuitry with just programming the CPLD.
