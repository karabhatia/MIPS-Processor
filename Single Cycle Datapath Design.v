`include "FADDER.v"
module ADDER_8bit(cfinal,sum,num1,num2,cin);
	
	input [7:0] num1,num2;
	output [7:0] sum;
	wire [7:0] cout;
	input cin;
	output cfinal;
	
		FADDER add0(sum[0],cout[0],num1[0],num2[0],cin);
		FADDER add1(sum[1],cout[1],num1[1],num2[1],cout[0]);
		FADDER add2(sum[2],cout[2],num1[2],num2[2],cout[1]);
		FADDER add3(sum[3],cout[3],num1[3],num2[3],cout[2]);
		FADDER add4(sum[4],cout[4],num1[4],num2[4],cout[3]);
		FADDER add5(sum[5],cout[5],num1[5],num2[5],cout[4]);
		FADDER add6(sum[6],cout[6],num1[6],num2[6],cout[5]);
		FADDER add7(sum[7],cout[7],num1[7],num2[7],cout[6]);
		
	assign cfinal = cout[7];
endmodule

`ifndef SC_DATAPATH
`define SC_DATAPATH
`include "im.v"
`include "dm.v"
`include "regFile.v"
`include "alu.v"
`include "aluCU.v"
`include "mainCU.v"
`include "signExt.v"
`include "shifter.v"
`include "fulladder_32bit.v"
`include "mux_2to1_32bit.v"
`include "reg_32bit.v"

`include "ADDER_8bit.v"

module adder_32bit(cfinal,sum,num1,num2,cin);
	input [31:0] num1,num2;
	input cin;
	output [31:0] sum;
	output cfinal;
	wire cout[3:0];
	
	ADDER_8bit add1(cout[0],sum[7:0],num1[7:0],num2[7:0],cin);
	ADDER_8bit add2(cout[1],sum[15:8],num1[15:8],num2[15:8],cout[0]);
	ADDER_8bit add3(cout[2],sum[23:16],num1[23:16],num2[23:16],cout[1]);
	ADDER_8bit add4(cout[3],sum[31:24],num1[31:24],num2[31:24],cout[2]);
	
	assign cfinal = cout[2];
	
endmodule


`ifndef ALU
`define ALU
    `include "fulladder_32bit.v"       //(sum,cout,num1, num2,cin );
    `include "module_32bitAND.v"        //module_32bitAND( outp, in1, in2 );
    `include "module_32bitOR.v"         //module_32bitOR( outp, in1, in2 );
    `include "mux_2to1_32bit.v"     //mux_2to1_32bit( outp, inp1, inp2, sel );
    `include "mux_3to1_32bit.v"     //mux_3to1_32bit( outp, inp1, inp2, inp3, sel );

    module alu( input [31:0] a, input [31:0] b, input cin, input binv,input reset, input [1:0] oper, output [31:0] result, output cout );

        wire [31:0] bbar, b_sel_bbar, a_and_b, a_or_b, a_addsub_b;

        assign bbar = ~b;

        mux_2to1_32bit mux2to1_op(b_sel_bbar, b, bbar, binv );
        module_32bitAND and_op( a_and_b, a, b_sel_bbar );
        module_32bitOR or_op( a_or_b, a, b_sel_bbar );
        fulladder_32bit fa_outp( a_addsub_b, cout, a, b_sel_bbar, cin );
        mux_3to1_32bit mux3to1_op( result, a_and_b, a_or_b, a_addsub_b, oper );

    endmodule
`endif

module aluCU( oper, aluOp, funcfield );
    
    input [1:0] aluOp;
    input [3:0] funcfield;
    output [2:0] oper;

    assign oper[0] = (funcfield[0] | funcfield[3]) & aluOp[1];
    assign oper[1] = ((~aluOp[1]) | (~funcfield[2]));
    assign oper[2] = (aluOp[0] | ( aluOp[1] & funcfield[1] ));

endmodule

`ifndef DM
`define DM	
	module DM(
	input [4:0] addr,
	input [31:0] data,
	input reset,
	input memWrite,
	input memRead,
	output [31:0] readData);
		
		reg [31:0] mem [0:31];
		
		always @(memWrite)
			if(~memRead)
				mem[addr] = data;
			
		always @(memRead)
			readData = mem[addr];
		
		always @(reset) begin
			if(reset) begin
				for( j=0; j<32; j = j+1) begin
					data[j] = 32'd0;
				end
			end
		end
		
	endmodule
`endif

`ifndef IM
`define IM
	module im(
		input [4:0] pc,
		input reset,
		output [31:0] instr);
		
		reg [31:0] mem[0:31];		//32 mem locns each 32 bit wide
		
		always @(pc)
			instr = mem[pc];
			
		always @(reset) begin
			if(reset) begin
				
				//initialization
				mem[0] = 32'h00000200;
				mem[1] = 32'h00000201;
				mem[2] = 32'h00000204;
				mem[3] = 32'h00000108;
				
			end
		end	
		
	endmodule
`endif

`ifndef REGFILE
`define REGFILE
`include "reg_32bit.v"      //q,d,clk,reset
`include "mux_4to1.v"       //regData,q0,q1,q2,q3,regNo
`include "decoder_2to4.v"   //register, regNo

    module regFile(
        input clk,
        input reset,
        input [1:0] readReg1,
        input [1:0] readReg2,
        input [31:0] writeData,
        input regWrite,
        input  [1:0] writeReg,
        output [31:0] readData1,
        output [31:0] readData2);
		
        genvar j;

        wire [3:0][31:0] regOut;
        reg [31:0] regIn;
        wire [3:0] decoderOut;
        wire [3:0] regClk;

        assign regClk[0] = (clk & regWrite & decoderOut[0]);
        assign regClk[1] = (clk & regWrite & decoderOut[1]);
        assign regClk[2] = (clk & regWrite & decoderOut[2]);
        assign regClk[3] = (clk & regWrite & decoderOut[3]);

        reg_32bit r0( regOut[0], regIn, regClk[0], reset );
        reg_32bit r1( regOut[1], regIn, regClk[1], reset );
        reg_32bit r2( regOut[2], regIn, regClk[2], reset );
        reg_32bit r3( regOut[3], regIn, regClk[3], reset );

        mux_4to1 m1( readData1, regOut[0] , regOut[1] , regOut[2], regOut[3], readReg1 );
        mux_4to1 m2( readData2, regOut[0] , regOut[1] , regOut[2] , regOut[3], readReg2 );
        decoder_2to4 dec1( decoderOut, writeReg );        

    endmodule
`endif

`ifndef REG_32BIT
`define REG_32BIT
`include "dff_sync_clear.v"         // d, clr, clk ,q
    module reg_32bit(
        output [31:0] q,
        input [31:0] d,
        input clk,
        input reset);

        genvar num;

        generate for (num = 0 ; num < 32 ; num = num + 1) begin: ffs
                dff_sync_clear dff( d[num], reset, clk, q[num] );
            end
        endgenerate
    endmodule
`endif
`ifndef SHIFTER
`define SHIFTER
	module shifter(
		input [31:0] inp,
		output [31:0] outp);
		
		assign outp = {inp[29:0],2'b00};
		
	endmodule
`endif

`ifndef SIGN_EXT
`define SIGN_EXT
		
	module signExt(
		input [15:0] inp,
		output [31:0] seOutp);	
		
		assign seOutp = {16{inp[15]},inp[15:0]};
		
	endmodule
`endif



	module SCDatapath(
		input reset,
	);
		
		//PC with address 0
		reg clk;
		reg [4:0] pcOut;
		reg5bit pc( 5'b0, clk, pcOut );
		
		//instr memory
		im instrMem( pc, reset , instr );
		
	
	endmodule
	
	module reg5bit(
	input [4:0] inp,
	input clk,
	output [4:0] outp);
		
		always @(posedge clk)	
			outp = inp;
		
	endmodule
`endif

