`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2023 10:27:54 PM
// Design Name: 
// Module Name: data_path
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


module data_path(
    input clk, rst, W_wr, Rp_rd, Rq_rd,
    input [1:0] RF_s,
    input [2:0] alu_s,
    input [3:0] W_addr, Rp_addr, Rq_addr,
    input [7:0] RF_W_data, // Sign extended into MUX
    input [15:0] R_data,
    output RF_Rp_zero, // Zero Flag
    output [15:0] W_data
    );
    wire [15:0] alu_output, rp_out, rq_out, MUX_out, sign_extension;
    
    // Mux together input from RF_s control signal
    assign MUX_out = (RF_s == 0) ? alu_output : (RF_s == 1) ? R_data : (RF_s == 2) ? sign_extension : 'bx;
    
    // Other outputs
    assign RF_Rp_zero = (rp_out == 0) ? 1'b1: 1'b0;
    
    assign W_data = rp_out;
    
    assign sign_extension = {{8{RF_W_data[7]}}, RF_W_data};
    
    RF_RISC RF(clk, rst, W_wr, Rp_rd, Rq_rd, W_addr, Rp_addr, Rq_addr, MUX_out, rp_out, rq_out);
    
    ALU_RISC ALU(rp_out, rq_out, alu_s, alu_output);
    
    
    
endmodule
