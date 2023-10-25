`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2023 10:43:11 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input zero, clk, rst, RF_Rp_zero,
    input [15:0] R_data, Rp_data,
    output D_addr_sel, D_rd, D_wr, RF_s1, RF_s0, W_wr, Rp_rd, Rq_rd, alu_s2, alu_s1, alu_s0,
    output [3:0] RF_W_addr, RF_Rp_addr, RF_Rq_addr,
    output [7:0] PC_addr, D_addr, RF_W_data,
    output [15:0] IR_to_seg
    );
    
    wire PC_ld, PC_JR, PC_clr, PC_inc, IR_ld;
    wire [7:0] PC_out, PC_added;
    wire [15:0] IR_out;
    
    // PC out to MUX
    assign PC_addr = PC_out;
    // Added PC for BNZ BIZ and J instructions
    assign PC_added = PC_out + IR_out[7:0] - 1;
    // Send IR address out to segment
    assign IR_to_seg = IR_out;
    
    // First line is inputs
    // Second line onwards is outputs
    controller_RISC Controller(zero, clk, rst, RF_Rp_zero, IR_out, 
    D_addr_sel, RF_s0, RF_s1, alu_s0, alu_s1, alu_s2, PC_ld, PC_JR, PC_clr, PC_inc, IR_ld, D_rd, 
    D_wr, W_wr, Rp_rd, Rq_rd, err_flag, D_addr, RF_W_data, RF_W_addr, RF_Rp_addr, RF_Rq_addr);
    
    program_counter PC(clk, rst, PC_ld, PC_JR, PC_clr, PC_inc, PC_added, Rp_data[7:0],
    PC_out);
    
    instruction_register IR(clk, rst, IR_ld, R_data, 
    IR_out);
    
    
    
endmodule
