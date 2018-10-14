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
`ifndef GLUE_GLUE_LOGIC_V
`define GLUE_GLUE_LOGIC_V

`include "interrupt_encoder.v"
`include "decoder_3_to_8.v"
`include "watchdog.v"

module glue_logic(
	input         clk,                       /* Clock              */
	input         as_n,                      /* Address strobe     */
	input         rw,                        /* Read / Write#      */
	input         lds_n,                     /* Lower data strobe  */
	input         uds_n,                     /* Upper data Strobe  */
	input  [2:0]  fc,                        /* CPU Status         */
	input  [2:0]  addr_lower,                /* Lower address bits */
	input  [5:0]  addr_upper,                /* Upper address bits */
	input  [6:0]  irq_n,                     /* IRQ1-IRQ7          */
	input         por_n,                     /* Power On Reset     */
	input         br_n,                      /* Bus Request        */
	input         bg_n,                      /* Bus Grant          */
	input         bgack_n,                   /* Bus Grant Ack      */
	input         vdp_irq_n,                 /* VDP IRQ            */
	input         vdp_wait_n,                /* VDP Wait           */
	output        reset_n,                   /* Reset              */
	output        halt_n,                    /* Halt               */
	output [2:0]  ipl_n,                     /* IPL0-IPL2          */
	output [6:0]  iack_n,                    /* IACK1-IACK7        */
	output        berr_n,                    /* Bus Error          */
	output        ram_sel_n,                 /* RAM select         */
	output        rom_sel_n,                 /* ROM select         */
	output        uart_sel_n,                /* UART select        */
	output        lord_n,                    /* Lower read         */
	output        lowr_n,                    /* Lower write        */
	output        uprd_n,                    /* Upper read         */
	output        upwr_n,                    /* Upper write        */
	inout         dtack_n,                   /* DTACK              */
	output        ben_n,                     /* Bus Buffers Enable */
	output        vpa_n,                     /* Valid Periph Addr. */
	output        vdp_rd_n,
	output        vdp_wr_n
);
	wire   cpu_iack     = fc[2:0] == 3'b111; /* IRQ ack cycle      */
	wire   strobe_n     = as_n | cpu_iack;   /* Bus cycle strobe   */

	assign vpa_n = 1'bZ;                     /* Ignore for now     */ 
	assign ben_n = 1'b0;                     /* Buffer always on   */

	/***************************************/
	/* Address Decoder                     */
	/***************************************/
	wire   ram_address_n; 
	wire   rom_address_n; 
	wire   uart_address_n;
	wire   vdp_address_n;
	wire   vdp_sel_n;

	assign rom_address_n  = addr_upper[3:0] != 4'b1111;   /* $f00000 - $ffffff */
	assign uart_address_n = addr_upper[5:0] != 6'b111011; /* $ec0000 - $efffff */
	assign vdp_address_n  = addr_upper[5:0] != 6'b111010; /* $e80000 - $ebffff */
	assign ram_address_n  = addr_upper[2:0] != 3'b000;    /* $000000 - $0fffff */

	assign ram_sel_n  = strobe_n | ram_address_n;
	assign rom_sel_n  = strobe_n | rom_address_n;
	assign uart_sel_n = strobe_n | uart_address_n;
	assign vdp_sel_n  = strobe_n | vdp_address_n;
	
	assign dtack_n = (ram_sel_n & rom_sel_n & ~vdp_wait_n) ? 1'bZ : 1'b0;

	/***************************************/
	/* Reset                               */
	/***************************************/
	assign reset_n = por_n ? 1'bZ : 1'b0;
	assign halt_n  = por_n ? 1'bZ : 1'b0;

	/***************************************/
	/* Interrupts                          */
	/***************************************/
	// TODO: Add autovectored interrupts
	// for VDP
	(*  keep="soft" *)
	wire dummy_irq;

	interrupt_encoder irq_encoder(
		.a_n(irq_n),
		.y_n(ipl_n)
	);

	decoder_3_to_8 irq_decoder(
		.a(addr_lower[2:0]),
		.e1_n(as_n),
		.e2_n(~cpu_iack),
		.e3(1'b1),
		.y_n({iack_n, dummy_irq})
	);

	/***************************************/
	/* Memory                              */
	/***************************************/
	wire   rd;
	assign rd = ~rw;
	assign lowr_n = rw | lds_n;
	assign lord_n = rd | lds_n;
	assign upwr_n = rw | uds_n;
	assign uprd_n = rd | lds_n;

	/***************************************/
	/* VDP                                 */
	/***************************************/
	assign vdp_wr_n = vdp_sel_n | rw;
	assign vdp_rd_n = vdp_sel_n | rd;

	/***************************************/
	/* Watchdog monitor                    */
	/***************************************/
	watchdog monitor(
		.clk(clk),
		.clr(as_n | ~por_n),
		.berr_n(berr_n)
	);
endmodule

`endif
