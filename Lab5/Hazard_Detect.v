//110550029
`timescale 1ns/1ps
module Hazard_Detect(
	ID_EX_MemRead_i,
	ID_EX_rt_i,
	IF_ID_rs_i,
	IF_ID_rt_i,
	PCWrite_o,
	IF_ID_Write_o,
	flush_o
	);
     
//I/O ports
input 		 ID_EX_MemRead_i;
input  [5-1:0]  ID_EX_rt_i, IF_ID_rs_i, IF_ID_rt_i;
output           PCWrite_o, IF_ID_Write_o, flush_o;

//Internal signals
reg 	PCWrite_o, IF_ID_Write_o, flush_o;

//Parameter

//Main function
always @(ID_EX_MemRead_i, ID_EX_rt_i, IF_ID_rs_i, IF_ID_rt_i) begin
	if(ID_EX_MemRead_i && ( ID_EX_rt_i==IF_ID_rs_i || ID_EX_rt_i==IF_ID_rt_i)) begin
		PCWrite_o=0;
		IF_ID_Write_o=0;
		flush_o=1;
	end
	else begin
		PCWrite_o=1;
		IF_ID_Write_o=1;
		flush_o=0;
	end
end

endmodule





                    
                    