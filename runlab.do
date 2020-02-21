# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./alu.sv"
vlog "./and_4.sv"
vlog "./and_16.sv"
vlog "./and_64.sv"
vlog "./bitWiseAnd.sv"
vlog "./bitWiseOr.sv"
vlog "./bitWiseXor.sv"
vlog "./control.sv"
vlog "./CPU.sv"
vlog "./D_FF.sv"
vlog "./datamem.sv" 
vlog "./datapath.sv"
vlog "./dec1_2.sv"
vlog "./dec2_4.sv"
vlog "./dec4_16.sv"
vlog "./Dec5_32.sv"
vlog "./DFF_VAR.sv"
vlog "./fullAdder.sv"
vlog "./fullAdder_VAR.sv"
vlog "./instructionDP.sv"
vlog "./instructmem.sv"
vlog "./mux2_1.sv"
vlog "./mux4_1.sv"
vlog "./mux8_1.sv"
vlog "./mux16_1.sv"
vlog "./mux32_1.sv"
vlog "./mux64_8x3.sv"
vlog "./not_VAR.sv"
vlog "./regfile.sv"
vlog "./signExtender.sv"
vlog "./Xmux2_1.sv"
vlog "./bitWiseXNor.sv"
vlog "./forward.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work CPU_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do CPU_testbench_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
