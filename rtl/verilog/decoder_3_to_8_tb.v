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
`include "decoder_3_to_8.v"

module interrupt_encoder_tb();
	reg [2:0] a;
	reg e1_n;
	reg e2_n;
	reg e3;
	wire [7:0] y_n;

	decoder_3_to_8 decoder(
		.a(a),
		.e1_n(e1_n),
		.e2_n(e2_n),
		.e3(e3),
		.y_n(y_n)
	);

	initial begin
		$dumpfile("decoder_3_to_8_tb.vcd");
		$dumpvars(0, decoder);

		a = 3'b010;
		e1_n = 0;
		e2_n = 0;
		e3   = 1;
		#1 e3 = 0;
		#1 e3 = 1;
		e2_n = 1;
		#1 e2_n = 0;
		a = 3'b101;
		#1 a = 3'b110;
		#1 a = 3'b011;

		#1 $finish;
	end
endmodule
