`ifndef PIPELINE_ALU
`define PIPELINE_ALU
`include "pipelineEnc.v"	

	module pipelineAlu(
		input [2:0] opcode,
		input [3:0] srcA,
		input [3:0] srcB,
		output [3:0] aluOut
	);
	
		wire [3:0] aluOut;
		
		assign aluOut = (opcode == `ADD) ? (srcA + srcB) :
						(opcode == `SUB) ? (srcA - srcB) :
						(opcode == `XOR) ? (srcA ^ srcB) :
						(opcode == `OR) ? (srcA | srcB) :
						(opcode == `AND) ? (srcA & srcB) :
						(opcode == `NOR) ? ~(srcA | srcB) :
						(opcode == `NAND) ? ~(srcA & srcB) :
						(opcode == `XNOR) ? ~(srcA ^ srcB) : 4'b0;
	
	
	endmodule
	
`endif

`ifndef PIPELINE_CIRCUIT
`define PIPELINE_CIRCUIT
`include "pipelineParGen.v"
`include "pipelineAlu.v"
`include "pipelineEnc.v"
		
	module pipelineCircuit(
		input [7:0] fncode,
		input [3:0] srcA,
		input [3:0] srcB,
		output parity
	);
		/*
			ToDo: Use these registers for implementation, Code not correct right now as per labsheet requirements.
		*/
		reg [10:0] IF_EXReg;
		reg [3:0] EX_PARReg;
		
		wire [2:0] opcode;
		wire [3:0] aluOut;
		
		pipelineEnc enc(fncode, opcode);
		pipelineAlu alu(opcode, srcA, srcB, aluOut);
		pipelineParGen pargen(aluOut, parity);
		
		
	endmodule
	
	
		
`endif

`ifndef PIPELINE_ENC
`define PIPELINE_ENC

`define ADD 3'b000
`define SUB 3'b001
`define XOR 3'b010
`define OR 3'b011
`define AND 3'b100
`define NOR 3'b101
`define NAND 3'b110
`define XNOR 3'b111

	module pipelineEnc(
		input [7:0] fncode,
		output [2:0] opcode);
		
		reg [2:0] opcode;

		always @(fncode) begin
			case (fncode)
				8'b00000001 : opcode = `ADD;
				8'b00000010 : opcode = `SUB;
				8'b00000100 : opcode = `XOR;
				8'b00001000 : opcode = `OR;
				8'b00010000 : opcode = `AND;
				8'b00100000 : opcode = `NOR;
				8'b01000000 : opcode = `NAND;
				8'b10000000 : opcode = `XNOR;
			endcase
		end
		
		
	endmodule
	
`endif


`ifndef PIPELINE_PAR_GEN
`define PIPELINE_PAR_GEN

	module pipelineParGen(
		input [3:0] aluOut,
		output parity
	);
		
		assign parity = aluOut[0] ^ aluOut[1] ^ aluOut[2] ^ aluOut[3];
		
	endmodule

`endif

`include "pipelineCircuit.v"
	module tb_pipeline();
		
		reg [7:0] fncode;
		reg [3:0] srcA, srcB;
		
		wire parity;
		
		pipelineCircuit pc(fncode, srcA, srcB, parity);
		
		initial begin
			
					fncode = 8'b00000001;
					srcA   = 4'b0001;
					srcB   = 4'b0001;
			
			#100	fncode = 8'b00000010;
			#200	fncode = 8'b00000100;
			#300	fncode = 8'b00001000;
			#400	fncode = 8'b00010000;
			#500	fncode = 8'b00100000;
			#600	fncode = 8'b01000000;
			#700	fncode = 8'b10000000;
			
			#10 	$display("");
			
			#100	fncode = 8'b00000001;
					srcA   = 4'b0101;
					srcB   = 4'b1010;
			
			#100	fncode = 8'b00000010;
			#200	fncode = 8'b00000100;
			#300	fncode = 8'b00001000;
			#400	fncode = 8'b00010000;
			#500	fncode = 8'b00100000;
			#600	fncode = 8'b01000000;
			#700	fncode = 8'b10000000;
		end
		
		initial begin
			$monitor( "fncode : %b ",fncode, " srcA: %b ", srcA," srcB: %b ", srcB, " aluOut: %b ",pc.aluOut, " parity: %b ", parity  );
		end
		
	endmodule
