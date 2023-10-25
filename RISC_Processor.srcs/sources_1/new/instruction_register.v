`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2023 02:06:59 PM
// Design Name: 
// Module Name: instruction_register
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


module instruction_register(
    input  clk, rst, IR_ld,
    input [15:0] R_data,
    output reg [15:0] IR_out
    );
    
    always @(posedge clk, negedge rst)
    begin
    if (rst==1'b0) IR_out <= 0;
    else if (IR_ld==1'b1) IR_out <= R_data;
    end
endmodule
