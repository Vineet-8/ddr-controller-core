# ####################################################################

#  Created by Genus(TM) Synthesis Solution 20.11-s111_1 on Tue May 19 17:50:36 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1fF
set_units -time 1000ps

# Set the current design
current_design ddr_controller_top

create_clock -name "clk" -period 5.0 -waveform {0.0 2.5} [get_ports clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports rst_n]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports user_req_valid]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports user_req_rnw]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {user_req_bank[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {user_req_bank[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {user_req_bank[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports user_req_ready]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports ddr_cs_n]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports ddr_ras_n]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports ddr_cas_n]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports ddr_we_n]
set_wire_load_mode "enclosed"
