//Subject:     CO project 2 - Simple Single CPU
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
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_in, pc_out, sum_0, sum_1, instr, ALU_result, RSdata, RTdata, se, src2, sft;
wire [5-1:0] RDaddr;
wire [4-1:0] ALUCtrl;
wire [3-1:0] ALU_op;
wire zero, branch, RegWrite, RegDst, ALUSrc;
reg [32-1:0] constant;

always @(posedge clk_i) begin
	if(~rst_i) constant=0;
	else constant=4;
end

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(constant),     
	    .src2_i(pc_out),     
	    .sum_o(sum_0)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(RDaddr) ,  
        .RDdata_i(ALU_result)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALU_op),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(instr[16-1:0]),
        .data_o(se)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(se),
        .select_i(ALUSrc),
        .data_o(src2)
        );	
		
ALU ALU(
        .src1_i(RSdata),
	    .src2_i(src2),
	    .ctrl_i(ALUCtrl),
	    .result_o(ALU_result),
		.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(sum_0),     
	    .src2_i(sft),     
	    .sum_o(sum_1)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(se),
        .data_o(sft)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(sum_0),
        .data1_i(sum_1),
        .select_i(branch&zero),
        .data_o(pc_in)
        );	

endmodule
		  


