//110550029
`timescale 1ns/1ps
module MUX_4to1(
               data0_i,
               data1_i,
               data2_i,
               data3_i,
               select_i,
               data_o
               );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i, data1_i, data2_i, data3_i;
input	[2-1:0]    select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function
always @(data0_i, data1_i, data2_i, data3_i, select_i) begin
	case(select_i) 
		2'b00: data_o<=data0_i;
		2'b01: data_o<=data1_i;
		2'b10: data_o<=data2_i;
		2'b11: data_o<=data3_i;
		default: data_o<=data0_i;
	endcase
end

endmodule      
          
          