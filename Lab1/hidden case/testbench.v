`timescale 1ns/1ps

// hidden case test
module testbench;

parameter PATTERN_NUMBER = 12;
integer i;

reg          clk;
reg          rst_n;
reg [32-1:0] src1_in;
reg [32-1:0] src2_in;
reg  [4-1:0] operation_in;

reg  [8-1:0] mem_src1   [0:(PATTERN_NUMBER*4-1)];
reg  [8-1:0] mem_src2   [0:(PATTERN_NUMBER*4-1)];
reg  [8-1:0] mem_opcode [0:(PATTERN_NUMBER-1)];
reg  [8-1:0] mem_result [0:(PATTERN_NUMBER*4-1)];
reg  [8-1:0] mem_zcv    [0:(PATTERN_NUMBER-1)];

reg  [6-1:0] pattern_count;
reg          start_check;
reg  [6-1:0] error_count;
reg  [6-1:0] error_count_tmp; 

wire [32-1:0] result_out;
wire          zero_out;
wire          cout_out;
wire          overflow_out;

wire  [3-1:0] zcv_out;
wire [32-1:0] result_correct;
wire  [8-1:0] zcv_correct;
wire  [8-1:0] opcode_tmp;
reg answer [0:11];

reg [32-1:0] grade;

assign zcv_out = {zero_out, cout_out, overflow_out};

assign opcode_tmp = mem_opcode[pattern_count];
assign result_correct = {mem_result[4 * (pattern_count - 5'd2) + 5'd3],
                         mem_result[4 * (pattern_count - 5'd2) + 5'd2],
                         mem_result[4 * (pattern_count - 5'd2) + 5'd1],
                         mem_result[4 * (pattern_count - 5'd2) + 5'd0]};
assign zcv_correct = mem_zcv[pattern_count - 5'd2];

initial begin
    clk   = 1'b0;
    rst_n = 1'b0;
    src1_in = 32'd0;
    src2_in = 32'd0;
    operation_in = 4'h0;
    start_check = 1'd0;
    error_count = 6'd0;
    error_count_tmp = 6'd0;
    pattern_count = 6'd0;
    grade = 32'd90;
    
    $readmemh("src1.txt", mem_src1);
    $readmemh("src2.txt", mem_src2);
    $readmemh("op.txt", mem_opcode);
    $readmemh("result.txt", mem_result);
    $readmemh("zcv.txt", mem_zcv);
    
    #20 rst_n = 1'b1;
    #15 start_check = 1'd1;
end

always #5 clk = ~clk;

alu alu(.clk(clk),
        .rst_n(rst_n),
        .src1(src1_in),
        .src2(src2_in),
        .ALU_control(operation_in),
        .result(result_out),
        .zero(zero_out),
        .cout(cout_out),
        .overflow(overflow_out)
);

always@(posedge clk) begin
    if(pattern_count == (PATTERN_NUMBER+1)) begin
		if(error_count == 5'd0) begin
			$display("***************************************************");
            $display("     Congratulation! All data are correct! ");
            $display("***************************************************");
		end
		
		$display("\n Total grade: %d \n",grade);
		
        $finish;
	end
    else if(rst_n) begin
		src1_in     <= {mem_src1[4 * pattern_count + 6'd3],
                        mem_src1[4 * pattern_count + 6'd2],
                        mem_src1[4 * pattern_count + 6'd1],
                        mem_src1[4 * pattern_count + 6'd0]};
        src2_in     <= {mem_src2[4 * pattern_count + 6'd3],
                        mem_src2[4 * pattern_count + 6'd2],
                        mem_src2[4 * pattern_count + 6'd1],
                        mem_src2[4 * pattern_count + 6'd0]};
        operation_in  <= opcode_tmp[4-1:0];
        pattern_count <= pattern_count + 6'd1;
	end
end

always@(negedge clk) begin
	if(start_check) begin
		if(pattern_count)
			if ((result_out != result_correct) || (zcv_out[2] != zcv_correct[2]) || ((mem_opcode[pattern_count - 2] == 4'd2 || mem_opcode[pattern_count - 2] == 4'd6) && (zcv_out[1:0] != zcv_correct[1:0])))begin
				$display("***************************************************");    
				case(mem_opcode[pattern_count - 2])
					4'd0:$display(" AND error! ");                  
					4'd1:$display(" OR error! ");
					4'd2:$display(" ADD error! ");
					4'd6:$display(" SUB error! ");
					4'd7:$display(" SLT error! ");
					4'd12:$display(" NOR error! ");
					default: begin
					end
				endcase
				
                answer[pattern_count - 2] = 0;

				$display(" No.%2d error!",pattern_count-1);
				$display(" Currect result: %h     Currect ZCV: %b",result_correct, zcv_correct[3-1:0]);
				$display(" Your result: %h     Your ZCV: %b\n",result_out, zcv_out);
				$display("***************************************************");    
				error_count <= error_count + 6'd1;
				grade <= grade - ((pattern_count - 1 <= 6) ? 32'd5 : 32'd10);
			end
            else begin
                answer[pattern_count - 2] = 1;
            end
	end
end

initial
	begin
		$dumpfile("test.vcd");
 		$dumpvars;
	end

endmodule
