//110550029
`timescale 1ns/1ps
module Branch(
	branch_i,
	zero_i,
	alu_msb_i,
	opcode_last3_i,
	branch_o
	);
     
//I/O ports
input 		 branch_i, zero_i, alu_msb_i;
input  [3-1:0]   opcode_last3_i;
output           branch_o;

//Internal signals
reg 	branch_o;

//Parameter

//Main function
always @(branch_i, zero_i, alu_msb_i,opcode_last3_i) begin
	if(branch_i) begin
		case(opcode_last3_i)
			3'b100: branch_o <= zero_i; //beq
			3'b101: branch_o <= ~zero_i; //bne
			3'b001: branch_o <= ~alu_msb_i; //bge
			3'b111: branch_o <= (~alu_msb_i)&(~zero_i); //bgt
			default: branch_o <= 0;
		endcase
	end
	else branch_o <= 0;
end

endmodule





                    
                    