#####################################################################
#####	             Route                                 #####
#####################################################################

source -echo /home/DuongTuong-ST/works/Projects/picorv32/setup/setup.tcl 

##open the design library
open_lib ${OUTPUT_LOCATION}

# Copy the imported block
copy_block -from ${DESIGN_NAME}/clock -to ${DESIGN_NAME}/route
open_block ${DESIGN_NAME}/route

set_lib_cell_purpose -include none {*/*_AO21* */*V2LP*}

# Setup application options
set_app_options -name route.global.force_rerun_after_global_route_opt -value true
set_app_options -name route.global.timing_driven -value true
set_app_options -name route.track.timing_driven -value true
set_app_options -name route.detail.timing_driven -value true
set_app_options -name opt.common.user_instance_name_prefix -value route

set_app_options    -name route.common.wire_on_grid_by_layer_name   -value {{M1 true } {M2 true} {M3 true}}
set_app_options    -name route.common.via_on_grid_by_layer_name    -value {{VIA1 false} {VIA2 true}}




# Routing constraint
set_ignored_layers \
	-min_routing_layer M1 \
	-max_routing_layer M7


#### Routing flow
sizeof_collection [get_nets -hierarchical *]
report_ignored_layers
report_scenarios

# Check the design
check_routability

# Global routing
route_global

# Track assignment and net routing
route_track

# Detail routing and DRC fixing
route_detail 

# route_auto command will run above 3 steps

#### Routing optimization
route_opt

#### Add redundant VIAs
add_redundant_vias 

#### ECO routing fix
route_eco

#### Check the routing
check_routes
check_lvs

#### Connect PG nets
connect_pg_net -net VDD [get_pins -hierarchical  */VDD]
connect_pg_net -net VSS [get_pins -hierarchical  */VSS]

# Analyze the design
check_legality 
report_congestion 
report_utilization
collect_reports route
get_blocks -all
list_blocks

save_block -as ${DESIGN_NAME}/route
save_lib


