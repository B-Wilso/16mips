![image](https://github.com/B-Wilso/16mips/assets/132187112/5ac264a7-51ac-4996-aac9-1e5628e431a1)# 16mips


# Look at the pdf named FPGA Final to see an evaluation of code written for a 16 bit 16 instruction mips processor:
https://github.com/B-Wilso/16mips/blob/main/FPGA%20FINAL.pdf

# Our object was to create a 16 bit 16 instruction MIPs processor, flash it onto an FPGA board, load set of instructions into memory to run, and display the IR and PC on the seven segement display.

|                 |             | 4-bit            | 4-bit | 4-bit     | 4-bit  |                                    |             |
|-----------------|-------------|------------------|-------|-----------|--------|------------------------------------|-------------|
|                 | Instruction | Instruction word |       |           |        | Action                             |             |
|                 |             | op               | dest  | src       | target |                                    |             |
| Data Processing | ADD         | 0000             | Rd    | Rs        | Rt     | dest <= src + targ                 | add         |
|                 | SUB         | 0001             | Rd    | Rs        | Rt     | dest <= src - targ                 | sub         |
|                 | AND         | 0010             | Rd    | Rs        | Rt     | dest <= src & targ                 | and         |
|                 | OR          | 0011             | Rd    | Rs        | Rt     | dest <= src | targ                 | or          |
|                 | XOR         | 0100             | Rd    | Rs        | Rt     | dest <= src ^ targ                 | xor         |
|                 | NOT         | 0101             | Rd    | Rs        | ??     | dest <= ~src                       | not         |
|                 | SLA         | 0110             | Rd    | Rs        | ??     | dest <= src << 1                   | shift left  |
|                 | SRA         | 0111             | Rd    | Rs        | ??     | dest <= src >> 1                   | shift right |
| Memory Access   | LI          | 1000             | Rd    | Immediate |        | dest <= Imm << 8                   | shift left  |
|                 | LW          | 1001             | Rd    | Dir       |        | dest <= Mem[Dir]                   | nop         |
|                 | SW          | 1010             | Rt    | Dir       |        | Mem[Dir] <= dest                   | nop         |
| Control Flow    | BIZ         | 1011             | Rs    | Offset    |        | if dest == 0; PC = PC + 1 + Offset | add         |
|                 | BNZ         | 1100             | Rs    | Offset    |        | if dest != 0; PC = PC + 1 + Offset | add         |
|                 | JAL         | 1101             | Rd    | Offset    |        | dest = PC+1; PC=PC+1+Offset        | add         |
|                 | JMP         | 1110             | ??    | Offset    |        | PC=PC+1+Offset                     | add         |
|                 | JR          | 1111             | ??    | Rs        | ??     | PC=src                             | nop         |

