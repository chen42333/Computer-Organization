//Subject:     CO project 2 - Adder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110550029
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Adder(
    src1_i,
	src2_i,
	sum_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
output [32-1:0]	 sum_o;

//Internal Signals
reg [32-1:0] sum_o;
reg [32-1:0] p, g, c;
reg [8-1:0] pp, gg;
reg [1:0] ppp, ggg;
integer i;

//Parameter
    
//Main function
always @(src1_i, src2_i) begin
	g=src1_i&src2_i;
	p=src1_i|src2_i;
	for(i=0; i<8; i=i+1) begin
		gg[i]=g[i*4+3]|(p[i*4+3]&g[i*4+2])|(p[i*4+3]&p[i*4+2]&g[i*4+1])|(p[i*4+3]&p[i*4+2]&p[i*4+1]&g[i*4]);
		pp[i]=p[i*4+3]&p[i*4+2]&p[i*4+1]&p[i*4];
	end
	for(i=0; i<2; i=i+1) begin
		ggg[i]=gg[i*4+3]|(pp[i*4+3]&gg[i*4+2])|(pp[i*4+3]&pp[i*4+2]&gg[i*4+1])|(pp[i*4+3]&pp[i*4+2]&pp[i*4+1]&gg[i*4]);
		ppp[i]=pp[i*4+3]&pp[i*4+2]&pp[i*4+1]&pp[i*4];
	end
	c[0]=0; c[16]=ggg[0]|(ppp[0]&c[0]);
	for(i=0; i<2; i=i+1) begin
		c[i*16+4]=gg[i*4]|(pp[i*4]&c[i*16]);
		c[i*16+8]=gg[i*4+1]|(pp[i*4+1]&c[i*16+4]);
		c[i*16+12]=gg[i*4+2]|(pp[i*4+2]&c[i*16+8]);
	end
	for(i=0; i<8; i=i+1) begin
		c[i*4+1]=g[i*4]|(p[i*4]&c[i*4]);
		c[i*4+2]=g[i*4+1]|(p[i*4+1]&c[i*4+1]);
		c[i*4+3]=g[i*4+2]|(p[i*4+2]&c[i*4+2]);
	end
	sum_o=p^g^c;
end

endmodule





                    
                    