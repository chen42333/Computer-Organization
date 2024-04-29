`timescale 1ns/1ps
// 110550029
module alu(
    /* input */
    clk,            // system clock
    rst_n,          // negative reset
    src1,           // 32 bits, source 1
    src2,           // 32 bits, source 2
    ALU_control,    // 4 bits, ALU control input
    /* output */
    result,         // 32 bits, result
    zero,           // 1 bit, set to 1 when the output is 0
    cout,           // 1 bit, carry out
    overflow        // 1 bit, overflow
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk;
input rst_n;
input [31:0] src1;
input [31:0] src2;
input [3:0] ALU_control;

output [32-1:0] result;
output zero;
output cout;
output overflow;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg [32-1:0] result;
reg zero, cout, overflow;
wire w[31:0], r[31:0];
wire set;
integer i;

/*==================================================================*/
/*                              design                              */
/*==================================================================*/

always@(posedge clk or negedge rst_n) 
begin
	if(!rst_n) begin
		result=32'b0;
		cout=0;
		overflow=0;
	end
	else begin
		for(i=0; i<=31; i++) result[i]=r[i];
		if(ALU_control[1:0]==2'b10) begin
			overflow=w[30]^w[31];
			cout=w[31];
		end
		else begin
			overflow=0;
			cout=0;
		end
	end
	zero=(result==0);
end

assign set=(src1[31]^ALU_control[3])^(src2[31]^ALU_control[2])^w[30];


/* HINT: You may use alu_top as submodule.*/
// 32-bit ALU
alu_top ALU00(.src1(src1[0]), .src2(src2[0]), .less(set), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(ALU_control[2]), .operation(ALU_control[1:0]), .result(r[0]), .cout(w[0]));
alu_top ALU01(.src1(src1[1]), .src2(src2[1]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[0]), .operation(ALU_control[1:0]), .result(r[1]), .cout(w[1]));
alu_top ALU02(.src1(src1[2]), .src2(src2[2]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[1]), .operation(ALU_control[1:0]), .result(r[2]), .cout(w[2]));
alu_top ALU03(.src1(src1[3]), .src2(src2[3]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[2]), .operation(ALU_control[1:0]), .result(r[3]), .cout(w[3]));
alu_top ALU04(.src1(src1[4]), .src2(src2[4]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[3]), .operation(ALU_control[1:0]), .result(r[4]), .cout(w[4]));
alu_top ALU05(.src1(src1[5]), .src2(src2[5]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[4]), .operation(ALU_control[1:0]), .result(r[5]), .cout(w[5]));
alu_top ALU06(.src1(src1[6]), .src2(src2[6]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[5]), .operation(ALU_control[1:0]), .result(r[6]), .cout(w[6]));
alu_top ALU07(.src1(src1[7]), .src2(src2[7]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[6]), .operation(ALU_control[1:0]), .result(r[7]), .cout(w[7]));
alu_top ALU08(.src1(src1[8]), .src2(src2[8]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[7]), .operation(ALU_control[1:0]), .result(r[8]), .cout(w[8]));
alu_top ALU09(.src1(src1[9]), .src2(src2[9]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[8]), .operation(ALU_control[1:0]), .result(r[9]), .cout(w[9]));
alu_top ALU10(.src1(src1[10]), .src2(src2[10]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[9]), .operation(ALU_control[1:0]), .result(r[10]), .cout(w[10]));
alu_top ALU11(.src1(src1[11]), .src2(src2[11]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[10]), .operation(ALU_control[1:0]), .result(r[11]), .cout(w[11]));
alu_top ALU12(.src1(src1[12]), .src2(src2[12]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[11]), .operation(ALU_control[1:0]), .result(r[12]), .cout(w[12]));
alu_top ALU13(.src1(src1[13]), .src2(src2[13]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[12]), .operation(ALU_control[1:0]), .result(r[13]), .cout(w[13]));
alu_top ALU14(.src1(src1[14]), .src2(src2[14]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[13]), .operation(ALU_control[1:0]), .result(r[14]), .cout(w[14]));
alu_top ALU15(.src1(src1[15]), .src2(src2[15]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[14]), .operation(ALU_control[1:0]), .result(r[15]), .cout(w[15]));
alu_top ALU16(.src1(src1[16]), .src2(src2[16]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[15]), .operation(ALU_control[1:0]), .result(r[16]), .cout(w[16]));
alu_top ALU17(.src1(src1[17]), .src2(src2[17]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[16]), .operation(ALU_control[1:0]), .result(r[17]), .cout(w[17]));
alu_top ALU18(.src1(src1[18]), .src2(src2[18]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[17]), .operation(ALU_control[1:0]), .result(r[18]), .cout(w[18]));
alu_top ALU19(.src1(src1[19]), .src2(src2[19]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[18]), .operation(ALU_control[1:0]), .result(r[19]), .cout(w[19]));
alu_top ALU20(.src1(src1[20]), .src2(src2[20]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[19]), .operation(ALU_control[1:0]), .result(r[20]), .cout(w[20]));
alu_top ALU21(.src1(src1[21]), .src2(src2[21]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[20]), .operation(ALU_control[1:0]), .result(r[21]), .cout(w[21]));
alu_top ALU22(.src1(src1[22]), .src2(src2[22]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[21]), .operation(ALU_control[1:0]), .result(r[22]), .cout(w[22]));
alu_top ALU23(.src1(src1[23]), .src2(src2[23]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[22]), .operation(ALU_control[1:0]), .result(r[23]), .cout(w[23]));
alu_top ALU24(.src1(src1[24]), .src2(src2[24]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[23]), .operation(ALU_control[1:0]), .result(r[24]), .cout(w[24]));
alu_top ALU25(.src1(src1[25]), .src2(src2[25]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[24]), .operation(ALU_control[1:0]), .result(r[25]), .cout(w[25]));
alu_top ALU26(.src1(src1[26]), .src2(src2[26]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[25]), .operation(ALU_control[1:0]), .result(r[26]), .cout(w[26]));
alu_top ALU27(.src1(src1[27]), .src2(src2[27]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[26]), .operation(ALU_control[1:0]), .result(r[27]), .cout(w[27]));
alu_top ALU28(.src1(src1[28]), .src2(src2[28]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[27]), .operation(ALU_control[1:0]), .result(r[28]), .cout(w[28]));
alu_top ALU29(.src1(src1[29]), .src2(src2[29]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[28]), .operation(ALU_control[1:0]), .result(r[29]), .cout(w[29]));
alu_top ALU30(.src1(src1[30]), .src2(src2[30]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[29]), .operation(ALU_control[1:0]), .result(r[30]), .cout(w[30]));
alu_top ALU31(.src1(src1[31]), .src2(src2[31]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(w[30]), .operation(ALU_control[1:0]), .result(r[31]), .cout(w[31]));


endmodule
