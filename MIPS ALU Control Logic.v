module ANDarray (RegDst,ALUSrc, MemtoReg, RegWrite,
MemRead, MemWrite,Branch,ALUOp1,ALUOp2,Op);
input [5:0] Op;
output RegDst,ALUSrc,MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2;
wire Rformat, lw,sw,beq;
assign Rformat= (~Op[0])& (~Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
assign lw= (Op[0])& (Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (Op[5]);
assign sw = (Op[0])& (Op[1])& (~Op[2])& (Op[3])& (~Op[4])& (Op[5]);
assign beq = (~Op[0])& (~Op[1])& (Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
assign RegDst=Rformat;
assign ALUSrc = lw | sw;
assign MemtoReg = lw;
assign RegWrite = lw | Rformat;
assign MemRead = lw;
assign MemWrite = sw;
assign Branch=beq;
assign ALUOp1 = Rformat;
assign ALUOp2 = beq;
endmodule

module test;
reg [5:0] op;
wire RegDst,ALUSrc,MemtoReg, RegWrite, MemRead,
MemWrite,Branch,ALUOp1,ALUOp2;
ANDarray anarr(RegDst,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2,op);
initial
begin
op=6'b000000;
#10 $display("op: ", op," RegDst: ", RegDst," ALUSrc: ", ALUSrc," MemtoReg: ",MemtoReg," RegWrite: ",RegWrite," MemRead: ",MemRead," MemWrite: ",MemWrite," Branch: ",Branch," ALUOp1: ",ALUOp1," ALUOp2: ",ALUOp2);
#10 op=6'b000001;
#10 $display("op: ", op," RegDst: ", RegDst," ALUSrc: ", ALUSrc," MemtoReg: ",MemtoReg," RegWrite: ",RegWrite," MemRead: ",MemRead," MemWrite: ",MemWrite," Branch: ",Branch," ALUOp1: ",ALUOp1," ALUOp2: ",ALUOp2);
#10 op=6'b000011;
#10 $display("op: ", op," RegDst: ", RegDst," ALUSrc: ", ALUSrc," MemtoReg: ",MemtoReg," RegWrite: ",RegWrite," MemRead: ",MemRead," MemWrite: ",MemWrite," Branch: ",Branch," ALUOp1: ",ALUOp1," ALUOp2: ",ALUOp2);
#10 op=6'b000010;
#10 $display("op: ", op," RegDst: ", RegDst," ALUSrc: ", ALUSrc," MemtoReg: ",MemtoReg," RegWrite: ",RegWrite," MemRead: ",MemRead," MemWrite: ",MemWrite," Branch: ",Branch," ALUOp1: ",ALUOp1," ALUOp2: ",ALUOp2);
#10 op=6'b000100;
#10 $display("op: ", op," RegDst: ", RegDst," ALUSrc: ", ALUSrc," MemtoReg: ",MemtoReg," RegWrite: ",RegWrite," MemRead: ",MemRead," MemWrite: ",MemWrite," Branch: ",Branch," ALUOp1: ",ALUOp1," ALUOp2: ",ALUOp2);
#10 op=6'b110011;
#10 $display("op: ", op," RegDst: ", RegDst," ALUSrc: ", ALUSrc," MemtoReg: ",MemtoReg," RegWrite: ",RegWrite," MemRead: ",MemRead," MemWrite: ",MemWrite," Branch: ",Branch," ALUOp1: ",ALUOp1," ALUOp2: ",ALUOp2);
#100 $finish;
end
endmodule
