///////////////////////////////////////////////////////////////////////////////
//  Copyright 2018 Fredrik A. Kristiansen
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "watchdog.v"

module watchdog_tb();
	reg clk;
	reg clr;
	wire berr_n;

	watchdog monitor(
		.clk(clk),
		.clr(clr),
		.berr_n(berr_n)
	);

	initial begin
		$dumpfile("watchdog_tb.vcd");
		$dumpvars(0, monitor);

		clk = 1'b0;
		clr = 1'b0;

		#120 clr = 1'b1;
		#1 clr = 1'b0;
		#260 clr = 1'b1;
		#1 clr = 1'b0;
		#10

		$finish;
	end

	always #1 clk = ~clk;
endmodule
