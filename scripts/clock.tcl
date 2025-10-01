#####################################################################
#####	             CTS                                        #####
#####################################################################

source -echo /home/DuongTuong-ST/works/Projects/picorv32/setup/setup.tcl 

##open the design library
open_lib ${OUTPUT_LOCATION}

# Copy the imported block
copy_block -from ${DESIGN_NAME}/place -to ${DESIGN_NAME}/clock
open_block ${DESIGN_NAME}/clock


# Set Cell Name Prefix
set_app_options -name cts.common.max_fanout -value 55
set_app_options -name cts.compile.enable_cell_relocation -value timing_aware
set_app_options -name cts.compile.size_pre_existing_cell_to_cts_references -value true
set_app_options -name cts.common.user_instance_name_prefix -value clock

# Improve routability
set_app_options    -name route.common.wire_on_grid_by_layer_name   -value {{M1 true } {M2 true} {M3 true}}
set_app_options    -name route.common.via_on_grid_by_layer_name    -value {{VIA1 false} {VIA2 true}}


#Apply Clock Design Rules  
set_max_transition 0.2 [get_clock clk] -clock_path
set_max_capacitance 300 [get_clock clk] -clock_path


#Specify Clock Driver Cell 
set_driving_cell -lib_cell SAEDRVT14_BUF_20 [get_ports clk]

#### Define cell usage during CTS
set_lib_cell_purpose -include cts {*/SAEDRVT14_BUF_2 */SAEDRVT14_BUF_4 */SAEDRVT14_BUF_6 */SAEDRVT14_BUF_8 */SAEDRVT14_BUF_16 */SAEDRVT14_BUF_20 \
                                   */SAEDRVT14_INV_1 */SAEDRVT14_INV_2 */SAEDRVT14_INV_4 */SAEDRVT14_INV_8 */SAEDRVT14_INV_16 */SAEDRVT14_INV_20} 

set_lib_cell_purpose -exclude cts {*/*DEL*}

set_lib_cell_purpose -exclude hold {*/*DEL*}

report_lib_cell -objects [get_lib_cells] -column {full_name:20 valid_purposes}

#Apply Non-Default Routing Rules (NDR) for Clock Nets 
create_routing_rule CLK_NDR \
	-default_reference_rule \
	-multiplier_width 2 \
	-multiplier_spacing 2 \
	-snap_to_track 
	
#Set Clock Routing Layer Constraints 
set_clock_routing_rules -rules CLK_NDR \
	-min_routing_layer M2 \
	-max_routing_layer M6

#Define Target Clock Skew
set_clock_tree_options -clocks [all_clocks] -target_skew 0.150

	 
#### clock_opt flow
get_clocks

# List the stages of clock_opt command
clock_opt -list_only

# Synthesize and optimize the clock tree
clock_opt -to build_clock

# Detail routing of clock
clock_opt -from build_clock -to route_clock 

# Optimization and legalization
clock_opt -to final_opto

#### Connect PG nets
connect_pg_net -net VDD [get_pins -hierarchical  */VDD]
connect_pg_net -net VSS [get_pins -hierarchical  */VSS]

# Analyze the design
check_legality 
report_congestion 
report_utilization
collect_reports clock

get_blocks -all
list_blocks

save_block  -as ${DESIGN_NAME}/clock
save_lib








