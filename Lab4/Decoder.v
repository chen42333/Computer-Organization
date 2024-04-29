//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110550029
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemToReg_o,
	MemRead_o,
	MemWrite_o,
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output	       MemToReg_o;
output	       MemRead_o;
output	       MemWrite_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            MemToReg_o;
reg            MemRead_o;
reg            MemWrite_o;

//Parameter
parameter R=3'b011;

//Main function

always @(instr_op_i) begin
	case(instr_op_i)
		6'b000000: begin //R-format
			ALU_op_o<=R; ALUSrc_o<=0; RegDst_o<=1; RegWrite_o<=1; Branch_o<=0;
			MemToReg_o<=0; MemRead_o<=0; MemWrite_o<=0;
		end
		6'b000100: begin //beq
			ALU_op_o<=3'b110; ALUSrc_o<=0; RegDst_o<=0; RegWrite_o<=0; Branch_o<=1;
			MemToReg_o<=0; MemRead_o<=0; MemWrite_o<=0;
		end
		6'b001000: begin //addi
			ALU_op_o<=3'b010; ALUSrc_o<=1; RegDst_o<=0; RegWrite_o<=1; Branch_o<=0;
			MemToReg_o<=0; MemRead_o<=0; MemWrite_o<=0;
		end
		6'b001010: begin //slti
			ALU_op_o<=3'b111; ALUSrc_o<=1; RegDst_o<=0; RegWrite_o<=1; Branch_o<=0;
			MemToReg_o<=0; MemRead_o<=0; MemWrite_o<=0;
		end
		6'b100011: begin //lw
			ALU_op_o<=3'b010; ALUSrc_o<=1; RegDst_o<=0; RegWrite_o<=1; Branch_o<=0;
			MemToReg_o<=1; MemRead_o<=1; MemWrite_o<=0;
		end
		6'b101011: begin //sw
			ALU_op_o<=3'b010; ALUSrc_o<=1; RegDst_o<=0; RegWrite_o<=0; Branch_o<=0;
			MemToReg_o<=0; MemRead_o<=0; MemWrite_o<=1;
		end
		default: begin
			ALU_op_o<=R; ALUSrc_o<=0; RegDst_o<=1; RegWrite_o<=1; Branch_o<=0;
			MemToReg_o<=0; MemRead_o<=0; MemWrite_o<=0;
		end
	endcase
end


endmodule





                    
                    