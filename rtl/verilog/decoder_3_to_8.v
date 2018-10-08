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
`ifndef GLUE_DECODER_3_TO_8_V
`define GLUE_DECODER_3_TO_8_V

module decoder_3_to_8(
	input  [2:0]     a,
	input            e1_n,
	input            e2_n,
	input            e3,
	output reg [7:0] y_n
);

	always @(e1_n or e2_n or e3 or a)
	begin
		if(e3 & ~e2_n & ~e1_n)
			case(a)
				0: y_n = 8'b11111110;
				1: y_n = 8'b11111101;
				2: y_n = 8'b11111011;
				3: y_n = 8'b11110111;
				4: y_n = 8'b11101111;
				5: y_n = 8'b11011111;
				6: y_n = 8'b10111111;
				7: y_n = 8'b01111111;
				default:
					y_n = 8'b11111111;
			endcase
		else
			y_n = 8'b11111111;
	end
endmodule

`endif
