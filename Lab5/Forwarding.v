//110550029
`timescale 1ns/1ps
module Forwarding(
	EX_MEM_rd_i,
	EX_MEM_RegWrite_i,
	MEM_WB_rd_i,
	MEM_WB_RegWrite_i,
	ID_EX_rs_i,
	ID_EX_rt_i,
	forward_src1_o,
	forward_src2_o
	);
     
//I/O ports
input  [5-1:0]  EX_MEM_rd_i, MEM_WB_rd_i, ID_EX_rs_i, ID_EX_rt_i;
input	EX_MEM_RegWrite_i, MEM_WB_RegWrite_i;
output [2-1:0]  forward_src1_o, forward_src2_o;

//Internal signals
reg 	forward_src1_o, forward_src2_o;

//Parameter

//Main function
always @(EX_MEM_rd_i, MEM_WB_rd_i, ID_EX_rs_i, ID_EX_rt_i, EX_MEM_RegWrite_i, MEM_WB_RegWrite_i) begin
	//initialize
	forward_src1_o = 2'b00; forward_src2_o = 2'b00;
	//EX hazard
	if(EX_MEM_RegWrite_i&&EX_MEM_rd_i!=0) begin
		if(EX_MEM_rd_i==ID_EX_rs_i) forward_src1_o=2'b01;
		if(EX_MEM_rd_i==ID_EX_rt_i) forward_src2_o=2'b01;
	end
	if(MEM_WB_RegWrite_i&&MEM_WB_rd_i!=0) begin
		if(MEM_WB_rd_i==ID_EX_rs_i && forward_src1_o==2'b00) forward_src1_o=2'b10;
		if(MEM_WB_rd_i==ID_EX_rt_i && forward_src2_o==2'b00) forward_src2_o=2'b10;
	end
end

endmodule





                    
                    