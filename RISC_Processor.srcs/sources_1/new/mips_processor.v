`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2023 11:36:49 PM
// Design Name: 
// Module Name: mips_processor
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


module mips_processor(
    input clk_i, rstn_i,
    output [7:0] disp_an_o, disp_seg_o
    );
    wire D_addr_sel, D_rd, D_wr, RF_s0, RF_s1, W_wr, Rp_rd, Rq_rd, alu_s0, alu_s1, alu_s2, RF_Rp_zero;
    wire [3:0] RF_W_addr, RF_Rp_addr, RF_Rq_addr;
    wire [7:0] PC_addr, D_addr, RF_W_data, addr;
    wire [15:0] W_data, R_data, IR_out;
    
    // pre-MEM MUX
    assign addr = (D_addr_sel == 1'b0) ? PC_addr : D_addr;
    
    
    // Slow down clock to see instructions
    reg clk_slow = 1'b0;
    reg [27:0] counter;
    
    always@(negedge rstn_i or posedge clk_i)
    begin
        if (rstn_i == 1'b0)
            begin
                clk_slow <= 0;
                counter <= 0;
            end
        else
            begin
                counter <= counter + 1;
                if ( counter == 1) // Was 10_000_000
                    begin
                        counter <= 0;
                        clk_slow <= ~clk_slow;
                    end
            end
    end
    
    // Add seven segment PC here
    
    seg_top_level sevenSeg(PC_addr, IR_out, clk_i, rstn_i, disp_an_o, disp_seg_o);
    
    // MIPS Control
    
    control_unit M0_control(zero, clk_slow, rstn_i, RF_Rp_zero, R_data, W_data, D_addr_sel, D_rd, D_wr, RF_s1, RF_s0, W_wr, 
    Rp_rd, Rq_rd, alu_s2, alu_s1, alu_s0, RF_W_addr, RF_Rp_addr, RF_Rq_addr, PC_addr, D_addr, RF_W_data, IR_out);
    
    data_memory M1_memory(clk_slow, D_rd, D_wr, // clock in, control read, control write
    addr, // Address location in 256 stack of memory
    W_data, // Data to write
    R_data);
    
    data_path M2_path(clk_slow, rstn_i, W_wr, Rp_rd, Rq_rd,
    {RF_s1, RF_s0},
    {alu_s2, alu_s1, alu_s0},
    RF_W_addr, RF_Rp_addr, RF_Rq_addr,
    RF_W_data, // Sign extended into MUX
    R_data,
    RF_Rp_zero, // Zero Flag
    W_data);
    
    
    
    
endmodule
