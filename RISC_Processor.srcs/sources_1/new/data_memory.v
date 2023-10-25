`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2023 04:41:44 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input clk, D_rd, D_wr, // clock in, control read, control write
    input [7:0] addr, // Address location in 256 stack of memory
    input [15:0] W_data, // Data to write
    output [15:0] R_data // Data read from memory and sent to registers
    );
    integer k;
    reg [15:0] memory [255:0];
    
    initial begin: Flush_Memory
    for(k=0;k<256;k=k+1) memory[k] = 0;
    end
    
    initial begin: Load_prgram
    #5
    memory[0] = 16'b1001_0101_1100_1001; // LW r5 <- Mem[201]
    memory[1] = 16'b1001_0110_1100_1010; // LW r6 <- Mem[202]
    memory[2] = 16'b0000_0111_0101_0110; // ADD r7 r5 r6
    memory[3] = 16'b1010_0111_1100_1011; // SW r7 -> Mem[203]
    memory[4] = 16'b1000_1000_1111_1010; // LI r8 <- 250
    memory[5] = 16'b0001_0100_1000_0101; // SUB r4 r8 r5
    memory[6] = 16'b1010_0100_1100_1100; // SW r4 -> Mem[204]
    memory[7] = 16'b0111_0011_0111_0000; // SRA r3 r7
    memory[8] = 16'b0100_0010_0011_0100; // XOR r2 r3 r4
    memory[9] = 16'b1010_0010_1100_1101; // SW r2 -> Mem[205]
    memory[201] = 16'd32;
    memory[202] = 16'd64;
    end
    
    // If control signal to write is enabled, write data to address
    always @(posedge clk)
    if (D_wr) memory[addr] <= W_data;
    
    // If read control signal is enabled, read ram @ address otherwise return 0
    assign R_data = (D_rd == 1) ? memory[addr] : {{8{addr[7]}}, addr}; // I changed this to MUX change back if broken
endmodule
