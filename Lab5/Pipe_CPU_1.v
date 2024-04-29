`timescale 1ns / 1ps
// 110550029
module Pipe_CPU_1(
    clk_i,
    rst_i
);
    
/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk_i;
input rst_i;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/
reg [32-1:0] constant;
/**** IF stage ****/
wire [32-1:0] pc_in, pc_out, sum_0_0, instr_0;

/**** ID stage ****/
wire [32-1:0] instr_1, sum_0_1, RSdata_0, RTdata_0, se_0;
wire [2-1:0] WB_0;
wire [3-1:0] M_0;
wire [5-1:0] EX;

/**** EX stage ****/
wire [32-1:0] instr_2, sum_0_2, sum_1_0, sft, RSdata_1, RTdata_1, src2, se_1, ALUresult_0, RSdata_final, RTdata_final;
wire [2-1:0] WB_1;
wire [3-1:0] M_1, ALUOp;
wire [4-1:0] ALUCtrl;
wire [5-1:0] RDaddr_0;
wire RegDst, ALUSrc, Zero_0;

/**** MEM stage ****/
wire [32-1:0] sum_1_1, ALUresult_1, RTdata_2, ReadData_0;
wire [2-1:0] WB_2;
wire [3-1:0] opcode_last3;
wire [5-1:0] RDaddr_1;
wire branch, MemWrite, MemRead, Zero_1, PCSrc;

/**** WB stage ****/
wire [32-1:0] ReadData_1, ALUresult_2, WriteData;
wire [5-1:0] RDaddr_2;
wire MemtoReg, RegWrite;

/**** Hazard & Forwarding ****/
wire flush, IF_ID_Write, PCWrite;
wire [2-1:0] forward_src1, forward_src2;

/*==================================================================*/
/*                              design                              */
/*==================================================================*/

always @(posedge clk_i) begin
	if(~rst_i) constant=0;
	else constant=4;
end

//Instantiate the components in IF stage

MUX_2to1 #(.size(32)) Mux0( // Modify N, which is the total length of input/output
	.data0_i(sum_0_0),
	.data1_i(sum_1_1),
	.select_i(PCSrc),
	.data_o(pc_in)
);

ProgramCounter PC(
        .clk_i(clk_i),
	.rst_i(rst_i),
	.pc_write(PCWrite),
	.pc_in_i(pc_in),
	.pc_out_o(pc_out)
);

Instruction_Memory IM(
        .addr_i(pc_out),
	.instr_o(instr_0)
);
			
Adder Add_pc(
        .src1_i(pc_out),
	.src2_i(constant),
	.sum_o(sum_0_0)
);
		
Pipe_Reg #(.size(64)) IF_ID( // Modify N, which is the total length of input/output
	.clk_i(clk_i),
	.rst_i(rst_i),
	.flush(PCSrc),
	.write(IF_ID_Write),
	.data_i({sum_0_0, instr_0}),
	.data_o({sum_0_1, instr_1})
);


//Instantiate the components in ID stage

Reg_File RF(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RSaddr_i(instr_1[25:21]),
	.RTaddr_i(instr_1[20:16]),
	.RDaddr_i(RDaddr_2),
	.RDdata_i(WriteData),
	.RegWrite_i(RegWrite),
	.RSdata_o(RSdata_0),
	.RTdata_o(RTdata_0)
);

Decoder Control(
	.instr_op_i(instr_1[31:26]),
	.RegWrite_o(WB_0[1]),
	.ALU_op_o(EX[3:1]),
	.ALUSrc_o(EX[0]),
	.RegDst_o(EX[4]),
	.Branch_o(M_0[2]),
	.MemToReg_o(WB_0[0]),
	.MemRead_o(M_0[1]),
	.MemWrite_o(M_0[0])
);

Sign_Extend SE(
	.data_i(instr_1[15:0]),
	.data_o(se_0)
);

Pipe_Reg #(.size(170)) ID_EX( // Modify N, which is the total length of input/output
	.clk_i(clk_i),
	.rst_i(rst_i),
	.flush(flush|PCSrc),
	.write(1'b1),
	.data_i({WB_0, M_0, EX, sum_0_1, RSdata_0, RTdata_0, se_0, instr_1}),
	.data_o({WB_1, M_1, RegDst, ALUOp, ALUSrc, sum_0_2, RSdata_1, RTdata_1, se_1, instr_2})
);

//Instantiate the components in EX stage

Shift_Left_Two_32 Shifter(
	.data_i(se_1),
	.data_o(sft)
);

ALU ALU(
	.src1_i(RSdata_final),
	.src2_i(src2),
	.ctrl_i(ALUCtrl),
	.result_o(ALUresult_0),
	.zero_o(Zero_0)
);
		
ALU_Ctrl ALU_Control(
	.funct_i(se_1[5:0]),
	.ALUOp_i(ALUOp),
	.ALUCtrl_o(ALUCtrl)
);

MUX_2to1 #(.size(32)) Mux1( // Modify N, which is the total length of input/output
	.data0_i(RTdata_final),
	.data1_i(se_1),
	.select_i(ALUSrc),
	.data_o(src2)
);
		
MUX_2to1 #(.size(5)) Mux2( // Modify N, which is the total length of input/output
	.data0_i(instr_2[20:16]),
	.data1_i(instr_2[15:11]),
	.select_i(RegDst),
	.data_o(RDaddr_0)
);

MUX_4to1 #(.size(32)) Mux3( // Modify N, which is the total length of input/output
	.data0_i(RSdata_1),
	.data1_i(ALUresult_1),
	.data2_i(WriteData),
	.data3_i(0),
	.select_i(forward_src1),
	.data_o(RSdata_final)
);

MUX_4to1 #(.size(32)) Mux4( // Modify N, which is the total length of input/output
	.data0_i(RTdata_1),
	.data1_i(ALUresult_1),
	.data2_i(WriteData),
	.data3_i(0),
	.select_i(forward_src2),
	.data_o(RTdata_final)
);

Adder Add_pc_branch(
	.src1_i(sum_0_2),
	.src2_i(sft),
	.sum_o(sum_1_0)
);

Pipe_Reg #(.size(110)) EX_MEM( // Modify N, which is the total length of input/output
	.clk_i(clk_i),
	.rst_i(rst_i),
	.flush(PCSrc),
	.write(1'b1),
	.data_i({WB_1, M_1, sum_1_0, Zero_0, ALUresult_0, RTdata_final, instr_2[28:26], RDaddr_0}),
	.data_o({WB_2, branch, MemRead, MemWrite, sum_1_1, Zero_1, ALUresult_1, RTdata_2, opcode_last3, RDaddr_1})
);


//Instantiate the components in MEM stage

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(ALUresult_1),
	.data_i(RTdata_2),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(ReadData_0)
);

Pipe_Reg #(.size(71)) MEM_WB( // Modify N, which is the total length of input/output
	.clk_i(clk_i),
	.rst_i(rst_i),
	.flush(1'b0),
	.write(1'b1),
	.data_i({WB_2, ReadData_0, ALUresult_1, RDaddr_1}),
	.data_o({RegWrite, MemtoReg, ReadData_1, ALUresult_2, RDaddr_2})
);

Branch Branch(
	.branch_i(branch),
	.zero_i(Zero_1),
	.alu_msb_i(ALUresult_1[31]),
	.opcode_last3_i(opcode_last3),
	.branch_o(PCSrc)
	);

//Instantiate the components in WB stage

MUX_2to1 #(.size(32)) Mux5( // Modify N, which is the total length of input/output
	.data0_i(ALUresult_2),
	.data1_i(ReadData_1),
	.select_i(MemtoReg),
	.data_o(WriteData)
);

//Hazard and forwarding

Forwarding Forwarding_Unit(
	.EX_MEM_rd_i(RDaddr_1),
	.EX_MEM_RegWrite_i(WB_2[1]),
	.MEM_WB_rd_i(RDaddr_2),
	.MEM_WB_RegWrite_i(RegWrite),
	.ID_EX_rs_i(instr_2[25:21]),
	.ID_EX_rt_i(instr_2[20:16]),
	.forward_src1_o(forward_src1),
	.forward_src2_o(forward_src2)
	);

Hazard_Detect Hazard_Detection_Unit(
	.ID_EX_MemRead_i(M_1[1]),
	.ID_EX_rt_i(instr_2[20:16]),
	.IF_ID_rs_i(instr_1[25:21]),
	.IF_ID_rt_i(instr_1[20:16]),
	.PCWrite_o(PCWrite),
	.IF_ID_Write_o(IF_ID_Write),
	.flush_o(flush)
	);

endmodule