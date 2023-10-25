`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2023 04:59:11 PM
// Design Name: 
// Module Name: RF_RISC
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


module RF_RISC(
    input clk, rst, W_wr, Rp_rd, Rq_rd,
    input [3:0] W_addr, Rp_addr, Rq_addr,
    input [15:0] W_data,
    output reg [15:0] Rp_data, Rq_data
    );
    
    integer i;
    // Register memory
    reg [15:0] reg_stack [15:0];
    
    // assign control_in = {W_wr, Rp_rd, Rq_rd};

    // Compile empty reg stack
    // on reset this should be triggered again
    
    /*initial begin
    for (i=0;i<16;i=i+1) reg_stack[i] <= 16'd0;
    end
    */
    
    // if write on clk write to the register
    // possibly concatenate signals then case?
    
    always @(posedge clk, negedge rst) begin
    
    if(rst==1'b0) 
    for (i=0;i<16;i=i+1) reg_stack[i] <= 16'd0; // RESET stack
    
    else begin
    // Normal operations ADD SUB etc 
    // These only require one cycle meaning no case
    if(Rp_rd)
    Rp_data <= reg_stack[Rp_addr];
    if(Rq_rd)
    Rq_data <= reg_stack[Rq_addr];
    if(W_wr)
    reg_stack[W_addr] <= W_data;
    end
    end
        
    
endmodule
