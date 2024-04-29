`timescale 1ns/1ps
// 110550029
module alu_top(
    /* input */
    src1,       //1 bit, source 1 (A)
    src2,       //1 bit, source 2 (B)
    less,       //1 bit, less
    A_invert,   //1 bit, A_invert
    B_invert,   //1 bit, B_invert
    cin,        //1 bit, carry in
    operation,  //2 bit, operation
    /* output */
    result,     //1 bit, result
    cout        //1 bit, carry out
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input src1;
input src2;
input less;
input A_invert;
input B_invert;
input cin;
input [1:0] operation;

output result;
output cout;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg result, cout;
wire AA, BB;

/*==================================================================*/
/*                              design                              */
/*==================================================================*/

assign AA=src1^A_invert;
assign BB=src2^B_invert;

/* HINT: You may use 'case' or 'if-else' to determine result.*/
// result
always@(*) begin
    case(operation)
	2'b00: begin result=AA&BB; cout=1'b0; end
	2'b01: begin result=AA|BB; cout=1'b0; end
	2'b10: begin result=AA^BB^cin; cout=(AA&BB)|(AA&cin)|(BB&cin); end
	2'b11: begin result=less; cout=(AA&BB)|(AA&cin)|(BB&cin); end
        default: 
		begin
            		result = 0;
        	end
    endcase
end


endmodule
