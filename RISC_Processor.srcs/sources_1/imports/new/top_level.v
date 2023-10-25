`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Brock Wilson
// 
// Create Date: 07/13/2023 12:57:42 PM
//////////////////////////////////////////////////////////////////////////////////


module seg_top_level(
input [7:0] PC_in, 
input [15:0] R_in,
input clk,
input rst,
output [7:0] disp_an_o,
output [7:0] disp_seg_o
    );
    
    reg [31:0] counter;
    reg [7:0] anode_select;
    reg [4:0] switch_hex;
    
    // DP set low
    assign disp_seg_o[7] = 1;
    // Convert to hex for cathodes
    sw_to_dec D1(.x(switch_hex), .cathode_y(disp_seg_o[6:0]));
    // Select certain anode
    assign disp_an_o = ~anode_select;
    
    
    // Set cathodes
    always @(anode_select) begin
    case(anode_select)
    8'b0000_0001: switch_hex = PC_in[3:0];
    8'b0000_0010: switch_hex = PC_in[7:4];
    8'b0000_0100: switch_hex = 12;
    8'b0000_1000: switch_hex = 16;
    8'b0001_0000: switch_hex = R_in[3:0]; // IR
    8'b0010_0000: switch_hex = R_in[7:4]; // IR
    8'b0100_0000: switch_hex = R_in[11:8]; // IR
    8'b1000_0000: switch_hex = R_in[15:12]; // IR
    default: switch_hex = 0;
    endcase
    end
    
    // If reset is pressed, reset loop
    // else every 10,000 ticks of clock, cycle to next anode to drive signal
    always @(posedge clk)begin
    if (~rst) begin
    anode_select <= 8'b0000_0000;
    counter <= 32'd0;
    end
    else if (anode_select == 8'b0000_0000) 
    anode_select <= 8'b0000_0001;
    else begin
    // Every 100,000 ticks of main clock
    // This drives signal every millisecond
    if (counter == 32'd100_000) begin
    // Reset clock and cycle anodes
    counter <= 32'd0;
    anode_select <= {anode_select[6:0], anode_select[7]};
    end
    // Increment counter
    else 
    counter <= counter + 1;
    end
    end
endmodule

