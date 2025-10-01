#####################################################################
#####	             Export                                     #####
#####################################################################

source -echo /home/DuongTuong-ST/works/Projects/picorv32/setup/setup.tcl 

##open the design library
open_lib ${OUTPUT_LOCATION}

# Copy the imported block
copy_block -from ${DESIGN_NAME}/route -to ${DESIGN_NAME}/export 
open_block ${DESIGN_NAME}/export 


# Set Cell Name Prefix
set_app_options -name cts.common.user_instance_name_prefix -value dfm

#DECAP cell insertion
set DECAP_CELLS [get_object_name [sort_collection -descending \
   [get_lib_cells */*_DCAP_V4*] area]]

create_stdcell_fillers -lib_cells ${DECAP_CELLS}

#### Filler cell insertion
set FILLER_CELLS [get_object_name [sort_collection -descending \
 [get_lib_cells */*_FILL* -filter "name !~ *Y2* AND name !~ *SPACER*"] area]]
 
create_stdcell_fillers -lib_cells ${FILLER_CELLS} 

# Remove placement blockage
remove_placement_blockages -all
create_stdcell_fillers -lib_cells ${FILLER_CELLS}
check_legality

add_redundant_vias

#### Connect PG nets
connect_pg_net -net VDD [get_pins -hierarchical  */VDD]
connect_pg_net -net VSS [get_pins -hierarchical  */VSS]


#### Analyze the design
check_legality 
report_congestion 
report_utilization
collect_reports export
#write out design data
write_verilog -include {pg_objects pg_netlist} /home/DuongTuong-ST/works/Projects/picorv32/results/${DESIGN_NAME}.pg.v

write_verilog -exclude {physical_only_cells} /home/DuongTuong-ST/works/Projects/picorv32/results/${DESIGN_NAME}.v

#write constraint
write_sdc -output /home/DuongTuong-ST/works/Projects/picorv32/results/${DESIGN_NAME}.spef

#### Write GDS
write_gds -design ${DESIGN_NAME} -layer_map ${GDS_MAP_FILE} -keep_data_type -fill include -output_pin all -merge_files ${GDS_FILE} -long_names -lib_cell_view frame  /home/DuongTuong-ST/works/Projects/picorv32/results/${DESIGN_NAME}.gds
	
get_blocks -all
list_blocks

save_block -as ${DESIGN_NAME}/export
save_lib

