#####################################################################
#####	             Flacement                                  #####
#####################################################################

source -echo /home/DuongTuong-ST/works/Projects/picorv32/setup/setup.tcl 

##open the design library
open_lib ${OUTPUT_LOCATION}

# Copy the imported block
copy_block -from ${DESIGN_NAME}/floorplan -to ${DESIGN_NAME}/place
open_block ${DESIGN_NAME}/place

# Setup application options
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name place_opt.final_place.effort -value high
set_app_options -name place_opt.place.congestion_effort -value high
set_app_options -name opt.common.user_instance_name_prefix -value place

# compile_fusion to initial_opto stage to get the design ready for placement and optimization
set_lib_cell_purpose -include none {*/*_AO21* */*V2LP*}
get_flat_cells -filter {ref_name=~*AO21* or ref_name=~*V2LP*}

# We can run one single command instead of the commands above
compile_fusion -to final_opto

# Connect PG nets
connect_pg_net -net VDD [get_pins -hierarchical  */VDD]
connect_pg_net -net VSS [get_pins -hierarchical  */VSS]

# Analyze the design
check_legality 
report_congestion 
report_utilization
collect_reports placement
get_blocks -all
list_blocks

save_block -as ${DESIGN_NAME}/place
save_lib

