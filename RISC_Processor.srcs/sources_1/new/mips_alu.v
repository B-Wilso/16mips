`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2023 03:20:08 PM
// Design Name: 
// Module Name: mips_alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_RISC#(parameter
// opcodes
ADD = 3'b000,
SUB = 3'b001,
AND = 3'b010,
OR = 3'b011,
XOR = 3'b100,
NOT = 3'b101,
SLA = 3'b110,
SRA = 3'b111
)(
    input [15:0] A, B,
    input [2:0] control, // Try to make 3 bits wide
    output reg [15:0] alu_out
    );
    // Source is A 
    // Target is B
    assign z_flag = ~|alu_out;
    
    
    always @(A, B, control)
    case(control)
    ADD: alu_out <= A + B;
    SUB: alu_out <= A - B;
    AND: alu_out <= A & B;
    OR: alu_out <= A | B;
    XOR: alu_out <= A ^ B;
    NOT: alu_out <= ~A;
    SLA: alu_out <= A << 1;
    SRA: alu_out <= A >> 1;
    default: alu_out = 0;
    endcase
    
endmodule
