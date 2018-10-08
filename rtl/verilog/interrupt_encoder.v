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
`ifndef GLUE_INTERRUPT_ENCODER_V
`define GLUE_INTERRUPT_ENCODER_V

module interrupt_encoder (
	input      [6:0] a_n,
	output reg [2:0] y_n
);
	always @(*)
	begin
		if(~a_n[6])
			y_n = 3'b000; // IRQ7
		else if(~a_n[5])
			y_n = 3'b001; // IRQ6
		else if(~a_n[4])
			y_n = 3'b010; // IRQ5
		else if(~a_n[3])
			y_n = 3'b011; // IRQ4
		else if(~a_n[2])
			y_n = 3'b100; // IRQ3
		else if(~a_n[1])
			y_n = 3'B101; // IRQ2
		else if(~a_n[0])
			y_n = 3'b110; // IRQ1
		else
			y_n = 3'b111; // IRQ0
	end
endmodule

`endif
