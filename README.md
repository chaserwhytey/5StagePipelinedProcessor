# 5-Stage Pipelined Processor
My partner and I created this processor in SystemVerilog as part of a project for computer architecture. We first programmed a single-cycle CPU, then for the final lab we pipelined it. We were required to simulate a CPU with hardware, so used logic gate functions with delays programmed into them. For the control module, we were allowed to use RTL. First, My partner created the regfile, ALU, control module, and the mux modules. I then wired these modules together to create a single-cycle CPU and the datapath for the program counter. He then debugged this code, and once this was finished, started pipelining the control signals and intermediate outputs within the CPU. I then finished the pipelining, created the forwarding unit, and debugged the pipelined CPU. The specs are below. We had a great teacher, Scott Hauck, and I learned so much in his class. He did an outstanding job of giving us all the tools that we needed to complete it. 

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
