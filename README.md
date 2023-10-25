# 16mips
Our objective was to create a 16 bit 16 instruction MIPs processor, flash it onto an FPGA board, load a set of instructions into memory to run, and display the IR and PC on the seven segement display. 

## To see an evaluation of the code refer to this review:
https://github.com/B-Wilso/16mips/blob/main/FPGA%20FINAL.pdf

## Overview of clock cycles based on instructions:
| Instruction | 1cc | 2cc | 3cc | 4cc |
| ---- | ---- | ---- | ---- | ---- |
| ALU (ADD, SUB, AND, OR, XOR, NOT, SLA, SRA) | FETCH: Fetches instruction and loads into IR | DECODE: Increments PC and loads Rp and Rq buses, at same time opcode is sent to ALU for computation | EXECUTION: Selects ALU datapath from MUX and writes to RF[W_addr] | ---- |
| LI | FETCH: Fetches instruction and loads into IR | DECODE: Increments PC and selects RF_W_data sign extended on MUX to write to RF[W_addr] | ---- | ---- |
| LW | FETCH: Fetches instruction and loads into IR | DECODE: Increments PC and writes MEM[D_addr] to RF[W_addr] register | ---- | ---- |
| SW | FETCH: Fetches instruction and loads into IR | DECODE: Increments PC and loads our DEST part of instruction code into Rp address bus | EXECUTION: Writes the input W_data into MEM[D_addr] | ---- |
| BIZ/BNZ | FETCH: Fetches instruction and loads into IR | DECODE: Increments PC and loads RF[RF_Rp_addr] | WAIT: RF_Rp_zero MUST be asserted during this time to check if Rp output is 0 or not | CHECK: Load offset into PC if RF_Rp output is zero or not; else return to FETCH |
| JAL | FETCH: Fetches instruction and loads into IR | DECODE: Increments PC and decodes instruction | EXECUTION: offsets PC | ---- |
| JR | FETCH: Fetches instruction and loads into IR | DECODE: Increments PC and loads RF[RF_Rp_addr] | EXECUTION: Loads the registers contents into PC without adding offset | ---- |

## Instruction overviews:
![image](https://github.com/B-Wilso/16mips/assets/132187112/5ac264a7-51ac-4996-aac9-1e5628e431a1)

## Control Signals to be asserted based on state transitions:
![image](https://github.com/B-Wilso/16mips/assets/132187112/6d0657cf-5aa4-41e5-8995-065700dc34b7)


