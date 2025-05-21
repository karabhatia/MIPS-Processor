module d_ff(q,d,clk,reset);
input d,clk,reset;
output q;
reg q;
always @(posedge clk) begin
if (reset)begin
q <= d;
end
else
assign q=0;
end
endmodule

module reg_32bit(q,d,clk,reset);
input [31:0] d;
input clk, reset;
output [31:0] q;
genvar j;
generate for (j=0;j<32;j=j+1) begin: lloop
d_ff d1(q[j],d[j],clk,reset);
end
endgenerate
endmodule
module tb32reg;
reg [31:0] d;
reg clk,reset;
wire [31:0] q;
reg_32bit R(q,d,clk,reset);
always @(clk)
#5 clk<=~clk;
initial
begin
clk= 1'b1;
reset=1'b0;//reset the register
#20 reset=1'b1;
#20 d=32'hAFAFAFAF;
#200 $finish;
end
endmodule

module mux4_1(regData,q1,q2,q3,q4,reg_no);
input [31:0] q1,q2,q3,q4;
input [1:0] reg_no;
output [31:0] regData;
reg [31:0] regData;
always @(reg_no)
begin
case(reg_no) 
2'b00: begin
regData = q1;
end
2'b01: begin
regData = q2;
end
2'b10: begin
regData = q3;
end
2'b11: begin
regData = q4;
end
default: begin
regData = q1;
end
endcase
end
endmodule


module decoder2_4 (register,reg_no);
input [1:0] reg_no;
output [3:0] register;
reg [3:0] register;
always @(reg_no)
begin
case(reg_no)
2'b00: begin
register = 4'b0001;
end
2'b01: begin
register = 4'b0010;
end
2'b10: begin
register = 4'b0100;
end
2'b11: begin
register = 4'b1000;
end
default: begin
register = 4'b0000;
end
endcase
end
endmodule


module test;
reg [31:0] q1,q2,q3,q4;
reg [1:0] reg_no;
wire [31:0] regData;
mux4_1 mm(regData,q1,q2,q3,q4,reg_no);
initial 
begin
q1 = 32'h00000001;
q2 = 32'h00000010;
q3 = 32'h00000002;
q4 = 32'h00000004;
reg_no = 2'b00;
#10 $display("reg_no: ", reg_no, " regData: ", regData);
#10 reg_no = 2'b01;
#10 $display("reg_no: ", reg_no, " regData: ", regData);
#10 reg_no = 2'b10;
#10 $display("reg_no: ", reg_no, " regData: ", regData);
#10 reg_no = 2'b11;
#10 $display("reg_no: ", reg_no, " regData: ", regData);
#10 reg_no = 2'b01;
#100 $finish;
end
endmodule

