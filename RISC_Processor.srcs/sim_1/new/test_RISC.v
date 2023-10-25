`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2023 12:25:57 AM
// Design Name: 
// Module Name: test_RISC
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


module test_RISC();
reg rst;
reg clk;
reg [15:0] k;


mips_processor M0(.clk_i(clk), .rstn_i(rst));

// Test bench clock
initial begin 
#0 clk = 0; 
forever #10 clk = ~clk;
end

// probes
wire [15:0] word0, word1, word2, word3, word4, word5, word6, word7, word8, word9, word201, word202;

assign 
word0 = M0.M1_memory.memory[0];
initial 
begin
#200 rst = 0; 
#10 rst = 1; 
$finish;
end

// Flush Memory
initial begin: Flush_Memory
#2 rst = 0; for(k=0;k<256;k=k+1) M0.M1_memory.memory[k] = 0; #10 rst = 1;
end

//initial begin: Load_prgram
//#5
//M0.M1_memory.memory[5] = 16'b1110_0000_0011_0000; // LW r5 201
//end

endmodule
