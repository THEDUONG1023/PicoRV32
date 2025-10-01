#####################################################################
#####			1.IMPORT                		#####
#####################################################################

#### Sourcing common setup script
source -echo /home/DuongTuong-ST/works/Projects/picorv32/setup/setup.tcl 

set REF_NDM   "frame_timing" ; 
set TECH_BASED "tf"           ;


#### Creating Design Library
puts "--- Creating design library ---"

if {[string equal frame_only ${REF_NDM}]} {
	set_app_var link_library "${DB_FF} ${DB_TT} ${DB_SS}"
	create_lib ${OUTPUT_LOCATION} -technology $TECH_FILE -ref_libs ${REFERENCE_LIBRARY}
	puts "Design library created: ${OUTPUT_LOCATION} with technology and NDM reference library (frame_only)."
} elseif {[string equal frame_timing ${REF_NDM}]} {
	if {[string equal ndm ${TECH_BASED}]} {
		lappend REFERENCE_LIBRARY ${TECH_NDM}
		create_lib ${OUTPUT_LOCATION} -use_technology_lib ${TECH_NDM} -ref_libs ${REFERENCE_LIBRARY}
		puts "Design library created: ${OUTPUT_LOCATION} using technology NDM and other reference libraries."
	} elseif {[string equal tf ${TECH_BASED}]} {
		create_lib ${OUTPUT_LOCATION} -technology $TECH_FILE -ref_libs ${REFERENCE_LIBRARY}
		
	} else {
		puts "Error: TECH_BASED variable's value is not 'ndm' or 'tf'. Please fix the value."
		exit 1
	}
} else {
	puts "Error: REF_NDM variable's value is not 'frame_only' or 'frame_timing'. Please fix the value."
	exit 1
}

puts "--- Design library creation complete ---"

#### Report reference libraries
report_ref_libs

#### Reading Netlist
#analyze -format verilog ${NETLIST_FILE}
read_verilog $NETLIST_FILE
# Elaborate
elaborate ${DESIGN_NAME}

# Set top module in the design
set_top_module ${DESIGN_NAME}

# Save block after netlist reading
save_block -as ${DESIGN_NAME}/netlist_read

source -echo /home/DuongTuong-ST/works/Projects/picorv32/setup/tech_setup.tcl

# Read the constraints
read_sdc -echo ${SDC_FILE}

source -echo ${MCMM_SETUP_SCRIPT}

# Setup application options
set_lib_cell_purpose -include none {*/*_AO21* */*V2LP*}
get_flat_cells -filter {ref_name=~*AO21* or ref_name=~*V2LP*}
set_app_options -name place.coarse.continue_on_missing_scandef -value true

report_timing

save_block -as ${DESIGN_NAME}/import

get_blocks -all

save_lib

exit
