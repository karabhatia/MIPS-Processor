module mux2to1(out,sel,in1,in2,in3);
 input in1,in2,in3;
 input [1:0] sel;
 output out;
 wire not_sel1,not_sel2,a1,a11,a2,a22,a3,a33,n1;
 not w1(not_sel1,sel[0]);
 not w2(not_sel2, sel[1]);
 and w3(a1, not_sel1, in1);
 and w4(a11, not_sel2, a1);
 and w5(a2, sel[0], in2);
 and w10(a22, not_sel2,a2);
 and w6(a3, not_sel1, in3);
 and w7(a33, sel[1], a3);
 or w8(n1, a11, a33);
 or w9(out, n1, a22);
endmodule

module bit8_2to1mux(out,sel,in1,in2,in3);
 input [7:0] in1,in2,in3;
 output [7:0] out;
 input [1:0] sel;
 mux2to1 m0(out[0],sel,in1[0],in2[0], in3[0]);
 mux2to1 m1(out[1],sel,in1[1],in2[1], in3[1]);
 mux2to1 m2(out[2],sel,in1[2],in2[2], in3[2]);
 mux2to1 m3(out[3],sel,in1[3],in2[3], in3[3]);
 mux2to1 m4(out[4],sel,in1[4],in2[4], in3[4]);
 mux2to1 m5(out[5],sel,in1[5],in2[5], in3[5]);
 mux2to1 m6(out[6],sel,in1[6],in2[6], in3[6]);
 mux2to1 m7(out[7],sel,in1[7],in2[7], in3[7]);
endmodule 
module bit32_use8(out, sel, in1, in2, in3);
	input [31:0] in1,in2, in3;
	input [1:0] sel;
	output [31:0] out;
	bit8_2to1mux d1(out[7:0],sel,in1[7:0],in2[7:0], in3[7:0]);
	bit8_2to1mux d2(out[15:8],sel,in1[15:8],in2[15:8], in3[15:8]);
	bit8_2to1mux d3(out[23:16],sel,in1[23:16],in2[23:16], in3[23:16]);
	bit8_2to1mux d4(out[31:24],sel,in1[31:24],in2[31:24], in3[31:24]);
	
endmodule
	
	
module tb_32bit2to1mux;
 reg [31:0] INP1, INP2, INP3;
 reg [1:0] SEL;
 wire [31:0] out;
 bit32_use8 M1(out,SEL,INP1,INP2, INP3);
 initial
 begin
 INP1=32'b00000000000000000000000010101010;
 INP2=32'b10000000000000000000000001010101;
 INP3=32'b00000000000000000000000000000001;
 $display("in1: ",INP1,"    in2: ", INP2,"    in3: ", INP3);
 SEL=2'b00;
 #100 SEL=2'b10;
 #20 $display("sel: ",SEL,"   out: ", out);
 #1000 $finish;
 end
endmodule

module bit32or(out, in1, in2);
	input [31:0] in1,in2;
	output [31:0] out;
	assign out = in1 | in2;
endmodule

module test;
	reg [31:0] in1, in2;
	wire [31:0] out;
	bit32or m1(out, in1, in2);
	initial
	begin
		in1 = 32'b00000000000000000000000000000010;
		in2 = 32'b00000000000000000000000000000001;
		#10 $display(" out: ", out);
		#100 in1 = 32'b00000000000000000000000000000100;
		#20 $display(" out: ", out);
		#1000 $finish;
	end
endmodule

module FA_dataflow (Cout, Sum,In1,In2,Cin);
 input [31:0] In1,In2;
 input Cin;
 output Cout;
 output [31:0] Sum;
 wire [31:0] c;
 assign c[0]=Cin;
 genvar j;
 generate for(j=0; j<31; j=j+1) 
 begin: adderloop
 assign {c[j+1],Sum[j]}=In1[j]+In2[j]+c[j];
 end
 endgenerate
 assign {Cout, Sum[31]} = In1[31]+In2[31] + c[31];
endmodule

module test;
reg [31:0] in1, in2;
reg cin;
wire [31:0] sum;
wire cout;
FA_dataflow f1(cout, sum, in1, in2, cin);
initial
begin
in1 = 32'b10000000000000000000000000000010;
in2 = 32'b10000000000000000000000000000110;
cin = 1'b0;
#10 $display("in1: ", in1, "  in2: ", in2, "  sum: ", sum, "  cout: ", cout);
#100 in1 = 32'b00000000000000000000000000001011;
#20 $display("  in1: ", in1, "  in2: ", in2, "  sum: ", sum, "  cout: ", cout);
#1000 $finish;
end
endmodule



