# 5StagePipelinedProcessor
This was processor was created as part of a project for computer architecture. Me and my partner worked on this throughout the quarter, completing it piece by piece. The code might look a little clunky, but we were required by the teacher to simulate an actual CPU with hardware, so we had to use logic gates with delays programmed into them. However, for the control module, we were allowed to use RTL. My partner created a lot of the building-block modules and the ALU. I wanted as much experience as I could get, so I tried to take on the bulk of the work by wiring the modules together, pipelining the CPU, creating the forwarding unit, and debugging the pipelined CPU. My partner helped in various places throughout these stages by debugging the single-cycle CPU and doing some of the pipelining as well. The specs are below. We had a great teacher, Scott Hauck, and I feel like a learned so much in his class. He did an outstanding job of giving us all the tools that we needed to complete it. 

Instruction set:
ADDI Rd, Rn, Imm12: Reg[Rd] = Reg[Rn] + ZeroExtend(Imm12).
ADDS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] + Reg[Rm]. Set flags.
B Imm26: PC = PC + SignExtend(Imm26 << 2).
 For lab #4 (only) this instr. has a delay slot.
B.LT Imm19: If (flags.negative != flags.overflow) PC = PC + SignExtend(Imm19<<2).
 For lab #4 (only) this instr. has a delay slot.
BL Imm26: X30 = PC + 4 (instruction after this one), PC = PC + SignExtend(Imm26<<2).
 For lab #4 (only) this instr. has a delay slot.
BR Rd: PC = Reg[Rd].
 For lab #4 (only) this instr. has a delay slot.
CBZ Rd, Imm19: If (Reg[Rd] == 0) PC = PC + SignExtend(Imm19<<2).
 For lab #4 (only) this instr. has a delay slot.
LDUR Rd, [Rn, #Imm9]: Reg[Rd] = Mem[Reg[Rn] + SignExtend(Imm9)].
For lab #4 (only) the value in rd cannot be used in the next cycle.
STUR Rd, [Rn, #Imm9]: Mem[Reg[Rn] + SignExtend(Imm9)] = Reg[Rd].
SUBS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] - Reg[Rm]. Set flags. 
