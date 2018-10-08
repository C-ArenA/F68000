WAVEFORMS:=interrupt_encoder_tb.vcd watchdog_tb.vcd decoder_3_to_8_tb.vcd
.PHONY: all clean

%.vbin: %.v
	iverilog -o $@ $<
%.vcd: %.vbin
	vvp $<

all:$(WAVEFORMS)
clean:
	rm -f *.vcd

