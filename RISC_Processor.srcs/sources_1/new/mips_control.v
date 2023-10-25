`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2023 01:17:21 PM
// Design Name: 
// Module Name: mips_control
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


module controller_RISC(
    input  zero, clk, rst, RF_Rp_zero,
    input [15:0] instruction,
    output D_addr_sel, RF_s0, RF_s1, alu_s0, alu_s1, alu_s2, // Any control signal to MUX should just be a wire
    output reg PC_ld, PC_JR, PC_clr, PC_inc, IR_ld, D_rd, D_wr, W_wr, Rp_rd, Rq_rd, err_flag, // Any control signal to different registers should be registers
    output [7:0] D_addr, RF_W_data, // I changed this from reg to wire *** IF THERES ERRORS ITS HERE ***
    output [3:0] RF_W_addr, RF_Rp_addr, RF_Rq_addr
    );
    // State Codes
    parameter S_idle = 0, S_fetch = 1, S_dec = 2, S_exec = 3, S_store = 4, S_jump = 5, S_JR = 6, S_halt = 7, S_check = 8, S_wait = 9;
    reg [3:0] state, next_state;
    
    // OP codes
    parameter ADD = 4'd0, SUB = 4'd1, AND = 4'd2, OR = 4'd3, XOR = 4'd4, NOT = 4'd5, SLA = 4'd6, SRA = 4'd7, LI = 4'd8, LW = 4'd9, SW = 4'd10, BIZ = 4'd11, BNZ = 4'd12, JAL = 4'd13, JMP = 4'd14, JR = 4'd15;
    
    // Break apart the IR Instruction
    wire [3:0] opcode = instruction[15:12];
    wire [3:0] dest = instruction[11:8]; 
    wire [3:0] src = instruction[7:4]; 
    wire [3:0] targ = instruction[3:0];
    
    // Custom registers for control signal outputs
    reg sel_PC_addr, sel_D_addr, sel_RF_W_data, sel_R_data, sel_ALU_data, JAL_assert;
    reg [2:0] ALU_control;
    
    // RF_W_data output 
    assign RF_W_data = {src, targ};
    
    // D_addr output
    assign D_addr = {src, targ};
    
    // D_addr_sel MUX output 
    assign D_addr_sel = sel_PC_addr ? 0 : sel_D_addr ? 1 : 1'bx;
    
    // RF_s MUX output
    assign {RF_s1, RF_s0} = sel_ALU_data ? 0 : sel_R_data ? 1 : sel_RF_W_data ? 2 : 2'bx;
    
    // ALU Control signal 
    assign {alu_s2, alu_s1, alu_s0} = ALU_control;
    
    // To the RF outputs
    assign RF_W_addr = dest;
    // Send destination to RP if SW-BIZ-BNZ
    // Else send src to RP
    assign RF_Rp_addr = (opcode == SW) ? dest : (opcode == BIZ) ? dest : (opcode == BNZ) ? dest : src;
    assign RF_Rq_addr = targ;
    
    // ALU Function select from opcode
    always @(opcode)
    case(opcode)
    ADD: ALU_control = 3'b000;
    SUB: ALU_control = 3'b001;
    AND: ALU_control = 3'b010;
    OR: ALU_control = 3'b011;
    XOR: ALU_control = 3'b100;
    NOT: ALU_control = 3'b101;
    SLA: ALU_control = 3'b110;
    SRA: ALU_control = 3'b111;
    default: ALU_control = 3'bxxx;
    endcase
    
    // Start cycling transitions on clock edges
    always @(posedge clk, negedge rst) begin: State_transitions
    if (rst == 0) state <= S_idle;
    else state <= next_state;
    end
    
    // State transitions
    always @(state, opcode, dest, src, targ, zero) begin: Output_and_next_state
    sel_PC_addr=0; sel_D_addr=0; sel_RF_W_data=0; sel_R_data=0; sel_ALU_data=0; PC_JR = 0; JAL_assert = 0;
    PC_ld=0; PC_clr=0; PC_inc=0; IR_ld=0; D_rd=0; D_wr=0; W_wr=0; Rp_rd=0; Rq_rd=0; err_flag=0;
    
    next_state = state;
    
    case(state)
    
    // Idle state that goes into fetch
    S_idle: next_state = S_fetch;
    
    // Send PC to MEM, load IR
    S_fetch:
    begin
    next_state = S_dec;
    sel_PC_addr = 1;
    D_rd = 1;
    IR_ld = 1;
    end
    
    // INC PC and decode instruction
    S_dec:
    begin
    PC_inc = 1;
    
    // Different Instructions
    case(opcode)
    // ALU Based instructions
    ADD, SUB, AND, OR, XOR, NOT, SLA, SRA:
    begin
    next_state = S_exec;
    Rp_rd = 1;
    Rq_rd = 1;
    end
    // LI based Instructions
    LI:
    begin
    next_state = S_fetch;
    sel_RF_W_data = 1;
    W_wr = 1;
    end
    // LW based Instructions
    LW:
    begin
    next_state = S_fetch;
    sel_D_addr = 1;
    W_wr = 1;
    D_rd = 1;
    sel_R_data = 1;
    end
    // SW based Instructions
    SW:
    begin
    next_state = S_store;
    Rp_rd = 1;
    end
    // BIZ/BNZ branch if/not equal zero
    BIZ, BNZ:
    begin
    next_state = S_wait;
    Rp_rd = 1;
    end
    // JUMP instructions
    JAL:
    begin
    next_state = S_jump;
    sel_PC_addr = 1;
    sel_R_data = 1;
    JAL_assert = 1;
    W_wr = 1;
    end
    // JMP
    JMP: next_state = S_jump;
    // JR
    JR:
    begin
    next_state = S_JR;
    Rp_rd = 1;
    end
    endcase
    end
    
    // Other states continued
    S_exec:
    begin
    next_state = S_fetch;
    W_wr = 1;
    sel_ALU_data=1;
    end
    
    // Storing Instructions
    S_store:
    begin
    next_state = S_fetch;
    sel_D_addr = 1;
    D_wr = 1;
    end
    
    S_wait: next_state = S_check;
    
    S_check:
    begin
    next_state = S_fetch;
    case(opcode)
    BIZ: PC_ld = (RF_Rp_zero == 1) ? 1 : 0; 
    BNZ: PC_ld = (RF_Rp_zero == 0) ? 1 : 0;
    endcase
    end
    
    S_jump:
    begin
    next_state = S_fetch;
    PC_ld = 1;
    end
    
    S_JR:
    begin
    next_state = S_fetch;
    PC_JR = 1;
    end
    
    S_halt: next_state = S_halt;
    default: next_state = S_idle;
    
    endcase
    end
    
endmodule
