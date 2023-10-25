`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2023 01:58:13 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input  clk, rst, PC_ld, PC_JR, PC_clr, PC_inc, // PC_ld loads input INTO PC
    input [7:0] data_in, JR_in, // Added with IR out
    output reg [7:0] PC_addr
    );
    
    always @(posedge clk, negedge rst) begin
    if(rst==1'b0) PC_addr <= 0;
    else if (PC_ld==1'b1) PC_addr <= data_in;
    else if (PC_JR==1'b1) PC_addr <= JR_in + 1;
    else if (PC_inc==1'b1) PC_addr <= PC_addr + 1;
    end
endmodule
