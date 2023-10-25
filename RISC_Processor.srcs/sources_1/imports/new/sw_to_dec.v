`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Brock Wilson
// 
// Create Date: 07/13/2023 12:33:21 PM
//////////////////////////////////////////////////////////////////////////////////


module sw_to_dec(
input wire [4:0] x,
output reg [6:0] cathode_y
    );
    
    always @(*)
    begin
    case(x)
    0: cathode_y = 7'b1000000;
    1: cathode_y = 7'b1111001;
    2: cathode_y = 7'b0100100;
    3: cathode_y = 7'b0110000;
    4: cathode_y = 7'b0011001;
    5: cathode_y = 7'b0010010;
    6: cathode_y = 7'b0000010;
    7: cathode_y = 7'b1111000;
    8: cathode_y = 7'b0000000;
    9: cathode_y = 7'b0010000;
    10: cathode_y = 7'b0001000;
    11: cathode_y = 7'b0000011;
    12: cathode_y = 7'b1000110;
    13: cathode_y = 7'b0100001;
    14: cathode_y = 7'b0000110;
    15: cathode_y = 7'b0001110;
    16: cathode_y = 7'b0001100;
    default: cathode_y = 7'b0111111;
    endcase
    end
    
endmodule
