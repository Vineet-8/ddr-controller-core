# synth.tcl
set_db library /home/vlsilab/SideV/saed90nm_typ.lib
# Note: Replace the above with your actual lab's standard cell .lib path
# set_db library {your_standard_cell_library.lib}

read_hdl -sv {
    textbook_fifo.v
    ddr_fsm.v
    ddr_controller_top.v
}

elaborate ddr_controller_top

# Define constraints
create_clock -name clk -period 5.0 [get_ports clk] 
# A 5.0ns period means we are targeting 200MHz

set_input_delay -clock clk 1.0 [all_inputs -no_clocks]
set_output_delay -clock clk 1.0 [all_outputs]

# Synthesize to generic logic, then map to standard cells
syn_generic
syn_map
syn_opt

# Generate Reports
report_timing > timing_report.rpt
report_area > area_report.rpt
report_power > power_report.rpt

write_hdl > ddr_controller_synth.v
write_sdc > ddr_controller.sdc

puts "Synthesis Complete!"
