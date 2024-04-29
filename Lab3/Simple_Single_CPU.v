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
wire [32-1:0] pc_in, pc_out, sum_0, sum_1, instr, ALU_result, RSdata, RTdata, se, src2, sft, WriteData, ReadData, result,jump_addr, next, next2;
wire [5-1:0] RDaddr, rs, rd;
wire [4-1:0] ALUCtrl;
wire [3-1:0] ALU_op;
wire zero, branch, RegWrite, RegDst, ALUSrc, MemToReg, jump, MemRead, MemWrite, wr, link, all_zeros;
reg [32-1:0] constant;

always @(posedge clk_i) begin
	if(~rst_i) constant=0;
	else constant=4;
end

assign jr= ~instr[5] & ~instr[4] & instr[3] & ~instr[2] & ~instr[1] & ~instr[0] & all_zeros;
assign wr=RegWrite & ~jr;

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
	
Shift_Left_Two_32 Shifter_Jump(
        .data_i(instr[25:0]),
        .data_o(jump_addr)
        ); 

MUX_2to1 #(.size(5)) Mux_jal(
        .data0_i(instr[20:16]),
        .data1_i(5'b11111),
        .select_i(link),
        .data_o(rd)
        );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(rd),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(RDaddr)
        );

MUX_2to1 #(.size(5)) Mux_Source_Reg(
        .data0_i(instr[25:21]),
        .data1_i(5'b11111),
        .select_i(jr),
        .data_o(rs)
        );

MUX_2to1 #(.size(32)) Mux_Write_Data(
        .data0_i(result),
        .data1_i(sum_0),
        .select_i(link),
        .data_o(WriteData)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(rs) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(RDaddr) ,  
        .RDdata_i(WriteData)  , 
        .RegWrite_i(wr),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALU_op),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch),
		.Link_o(link),
		.jump_o(jump),
		.MemToReg_o(MemToReg),
		.MemRead_o(MemRead),
		.MemWrite_o(MemWrite)  ,
		.all_zeros_o(all_zeros)
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
Data_Memory Data_Memory(
        .clk_i(clk_i),      
	.addr_i(ALU_result),
	.data_i(RTdata),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(ReadData) 
        );
		
MUX_2to1 #(.size(32)) Mux_Result_Data(
        .data0_i(ALU_result),
        .data1_i(ReadData),
        .select_i(MemToReg),
        .data_o(result)
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
		
MUX_2to1 #(.size(32)) Mux_Next(
        .data0_i(sum_0),
        .data1_i(sum_1),
        .select_i(branch&zero),
        .data_o(next)
        );

MUX_2to1 #(.size(32)) Mux_Next2(
        .data0_i(next),
        .data1_i({sum_0[31:28],jump_addr[27:0]}),
        .select_i(jump),
        .data_o(next2)
        );	

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(next2),
        .data1_i(RSdata),
        .select_i(jr),
        .data_o(pc_in)
        );

endmodule
		  


