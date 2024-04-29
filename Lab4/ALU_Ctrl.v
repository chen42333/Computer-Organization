//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
parameter R=3'b011;
       
//Select exact operation
always @(funct_i, ALUOp_i) begin
	if(ALUOp_i==R) begin
		case(funct_i)
			24: ALUCtrl_o<=4'b1111; //mult
			32: ALUCtrl_o<=4'b0010; //add
			34: ALUCtrl_o<=4'b0110; //sub
			36: ALUCtrl_o<=4'b0000; //AND
			37: ALUCtrl_o<=4'b0001; //OR
			38: ALUCtrl_o<=4'b0011; //XOR
			42: ALUCtrl_o<=4'b0111; //slt
		endcase
	end
	else begin
		ALUCtrl_o[2:0]<=ALUOp_i;
		ALUCtrl_o[3]=1'b0;
	end
end

endmodule     





                    
                    